# sonar-scanner action
Use this action to trigger a SonarQube scan of your code from any 
Github Actions workflow, similar to using the `sonar runner` stage in a Gitlab project.

## Inputs
* [`sonar-scanner-image`](#sonar-scanner-image): [**required**] A Docker image running a
[cli version of SonarScanner](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/).
* [`sonar-token`](#sonar-token): [**required**] A 
[SonarQube user token](https://docs.sonarqube.org/6.7/UserToken.html) from the SonarQube
server specified by [`sonar-host-url`](#sonar-host-url).
* [`sonar-host-url`](#sonar-host-url): [*optional*] The SonarQube server to perform the 
scan.
* [`sonar-project-base-dir`](#sonar-project-base-dir): [*optional*] By default, a scan 
will be performed on the current directory of the job using this action; if, as is most
likely, you used the [actions/checkout](https://github.com/actions/checkout) action in a 
previous step, this will be your project's root directory. In rare cases (perhaps you
used [actions/checkout](https://github.com/actions/checkout)'s `path` parameter to 
checkout into some subdirectory, or maybe you have multiple projects off of root and only
want to scan a particular one), a value specifying the subdirectory to scan can be
supplied here.

In any case, a [`sonar-project.properties`](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/#header-1)
file must be present in your project to 
[configure your analysis](https://docs.sonarqube.org/latest/analysis/analysis-parameters/).
This file should exist at root, if [`sonar-project-base-dir`](#sonar-project-base-dir) is 
not specified, or in [`sonar-project-base-dir`](#sonar-project-base-dir) if it is 
specified, and it must contain at least a value for `sonar.projectKey`.

## Example usage

```yaml
on: push

jobs:
  scan-my-project:
    runs-on: self-hosted
    steps:
    - uses: actions/checkout@v2
      name: checkout project
    - uses: actions/setup-java@v1
      with:
        java-version: 1.8
      name: get java, maven
    - run: mvn -B package
      name: package code
    - uses: actions/checkout@v2
      with:
        repository: andy-crain-kr/sonar-scanner
        path: .github/actions/sonar-scanner
        ref: v1
        token: ${{ secrets.GITHUB_TOKEN }}
      name: checkout scanner
    - uses: ./.github/actions/sonar-scanner
      with:
        sonar-token: ${{ secrets.SONAR_TOKEN }}
      name: scan code
```

In the code above, the key bits are the last two steps. First, this action is checked out
locally to the runner:
```yaml
    - uses: actions/checkout@v2
      with:
        repository: andy-crain-kr/sonar-scanner
        path: .github/actions/sonar-scanner
        ref: v1
        token: ${{ secrets.GITHUB_TOKEN }}
```
This explicit checkout is required because it's not yet possible to directly reference 
private Github actions--i.e. you can't just say `uses: andy-crain-kr/sonar-scanner@v1` 
as you would for a public action. This step checks out `sonar-scanner` into 
`.github/actions/sonar-scanner` on the runner (so be sure you don't have your own code 
at that path; adjust if so), using a personal access token for authorization. To enable 
this, you'll need to first 
[create a personal access](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) 
token with `repo` scope and SSO enabled, then create a secret in your repository holding 
it. Here the token is stored in a secret named `GITHUB_TOKEN`.

The second step simply specifies parameters for the scanner, in this case specifying the 
only required parameter, `sonar-token`, which is configured as a secret in the scanned 
repository:
```yaml
    - uses: ./.github/actions/sonar-scanner
      with:
        sonar-token: ${{ secrets.GITHUB_SONAR_TOKEN }}
      name: scan code
``` 

## Support

For help and support, please create an issue or check 
[Core Engineering's Building Blocks channel in Teams](https://teams.microsoft.com/l/channel/19%3aa336ee819cfc4e41926a198adab419cc%40thread.skype/Building%2520Blocks?groupId=02803b36-e5d8-4d81-bb33-c0c36d90d49e&tenantId=8331e14a-9134-4288-bf5a-5e2c8412f074).
