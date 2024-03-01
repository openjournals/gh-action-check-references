# Open Journals :: Check bibtex references

This action checks the validity of the bibliographic references of a paper submitted to Open Journals for review.

The path to the `.bib` file is extracted from the metadata of the paper file under the `bibliography` entry.

### Inputs

The action accepts the following inputs:

- **issue_id**: Required. The review issue id of the submission for the paper.
- **repository_url**: Required. The repository URL of the submission containing the paper file.
- **branch**: Optional. Git branch where the paper is located.

### ENV

For the action to be able to add labels and post comments to the review issue there must be two env vars setted with valid values:

- **GITHUB_TOKEN**: The token of the user posting the results of the checks
- **GH_REPO**: The repository where the review issue is found, in `username/repo-name` format

### Example

Sample use as a step in a workflow `.yml` file in a repo's `.github/workflows/` directory, setting `env` and passing custom input values:

````yaml
name: Repository and paper info
on:
  workflow_dispatch:
    inputs:
      issue_id:
        description: 'The issue number of the submission to post the results'
env:
  GITHUB_TOKEN: ${{ secrets.BOT_USER_TOKEN }}
  GH_REPO: myorg/reviews
jobs:
  run-analysis:
    runs-on: ubuntu-latest
    steps:
      - name: DOI validation
        uses: openjournals/gh-action-check-references@main
        with:
          repository_url: http://github.com/${{ github.repository }}
          branch: paper
          issue_id: ${{ github.event.inputs.issue_id }}
```
