# Welcome to EncounterPro_OS contributing guide

Thank you for investing your time in contributing to our project! Any contribution you make will be reflected in
[this repository](https://github.com/christillman/encounterpro_os) :sparkles:.

Read our [Code of Conduct](./CODE_OF_CONDUCT.md) to keep our community approachable and respectable.

In this guide you will get an overview of the contribution workflow from opening an issue, creating a PR, reviewing, and merging the PR.

## New contributor guide

For an overview of the project, read the [README](README.md). Here are some suggestions to help you get started with contributions:

### Documentation

#### Install our sample/test application to become familiar with the way EncounterPro_OS works (sample/test application coming soon).

#### Write documentation for EncounterPro_OS users or developers. We have some existing user documentation in the Help folder which builds to a Windows 
CHM file, but it is woefully out of date.

### Issues

Scan through our [existing issues](https://github.com/christillman/encounterpro_os/issues) to find one that interests you. You can narrow down the search using `labels` as filters. See [Labels](/contributing/how-to-use-labels.md) for more information. 

#### Create a new issue

If you run into a problem with EncounterPro_OS, [search if an issue already exists](https://github.com/christillman/encounterpro_os/issues). If a related issue doesn't exist, you can open a new issue using a relevant [issue form](https://github.com/christillman/encounterpro_os/issues/new/choose).

#### Validate and provide replication instructions for an issue.
#### Add context or additional information to an issue.
#### Propose an issue solution in discussions.

#### Solve an issue

As a general rule, we don’t assign issues to anyone. If you find an issue to work on, you are welcome to open a Pull Request (see below) with a fix.

#### Test a pending pull request on your own copy of the repository.

### Make Changes

#### Evaluate, update, or prepare country drug lists. We currently use RXNORM for U.S. medicines, and have imports for Kenya and Uganda.

#### Make changes in a codespace

For more information about using a codespace for working on GitHub documentation, see "[Working in a codespace](https://github.com/github/docs/blob/main/contributing/codespace.md)."

#### Make changes locally

1. Clone the source so you can make and test development changes in your own environment.
- Using GitHub Desktop:
  - [Getting started with GitHub Desktop](https://docs.github.com/en/desktop/installing-and-configuring-github-desktop/getting-started-with-github-desktop) will guide you through setting up Desktop.
  - Once Desktop is set up, you can use it to [fork the repo](https://docs.github.com/en/desktop/contributing-and-collaborating-using-github-desktop/cloning-and-forking-repositories-from-github-desktop)!

- Using the command line:
  - [Fork the repo](https://docs.github.com/en/github/getting-started-with-github/fork-a-repo#fork-an-example-repository) so that you can make your changes without affecting the original project until you're ready to merge them.

2. Install or update to **Node.js**, at the version specified in `.node-version`. For more information, see [the development guide](contributing/development.md).

3. Create a working branch and start with your changes!

### Commit your update

Commit the changes once you are happy with them.

### Pull Request

#### Submit a pull request once you have a modification working. See [general information about pull requests](https://docs.github.com/en/github/collaborating-with-pull-requests)

When you're finished with the changes, create a pull request, also known as a PR.
- Fill the "Ready for review" template so that we can review your PR. This template helps reviewers understand your changes as well as the purpose of your pull request.
- Don't forget to [link PR to issue](https://docs.github.com/en/issues/tracking-your-work-with-issues/linking-a-pull-request-to-an-issue) if you are solving one.
- Enable the checkbox to [allow maintainer edits](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/allowing-changes-to-a-pull-request-branch-created-from-a-fork) so the branch can be updated for a merge.
Once you submit your PR, a team member will review your proposal. We may ask questions or request additional information.
- We may ask for changes to be made before a PR can be merged, either using [suggested changes](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/incorporating-feedback-in-your-pull-request) or pull request comments. You can apply suggested changes directly through the UI. You can make any other changes in your fork, then commit them to your branch.
- As you update your PR and apply changes, mark each conversation as [resolved](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/commenting-on-a-pull-request#resolving-conversations).
- If you run into any merge issues, checkout this [git tutorial](https://github.com/skills/resolve-merge-conflicts) to help you resolve merge conflicts and other issues.

### Your PR is merged!

Congratulations :tada::tada: 

Once your PR is merged, your contributions will be publicly visible on the [this repository](https://github.com/christillman/encounterpro_os).
