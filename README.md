# 1Password-document-exporter

Current versions of the 1Password apps (version 7.x at the time of writing) do not include Document items if you export your data. Whether you want to switch to a new password manager and take your existing data with you, or if you just want to make a backup, the only currently recommended solution is to download the files manually, and make a copy yourself. It's clearly a very ugly solution, but this could work if you only have a handful of Document items. If you have hundreds or more of them though, it's just not a feasible solution.

This script uses the 1Password CLI to fetch all your Document items for you, and exports them to your Downloads folder. It can download Document items from every vault you have access to in your 1Password account (so if you are an Admin in a Families or Business account, you can get Documents also from shared vaults at the same time, not just those from your Private vault).

## Example Output

```
[1/32] Exporting document My Passport.pdf
[2/32] Exporting document My Driver License.JPG
[3/32] Exporting document My Screenshot.JPG
[4/32] Exporting document My zip file.zip
[5/32] Exporting document My Document.pdf
[...]
```

Exported files will be stored under `/Users/your_current_user/Downloads/1PasswordDocuments`.

There will be one subfolder for each source vault which contains Document items to export, so you know where each document is coming from exactly.

## Prerequisites

- [The 1Password CLI tool](https://support.1password.com/command-line-getting-started/)
- [jq](https://stedolan.github.io/jq/)

## Usage

- Make the 1password-document-export.sh executable with chmod +x 1password-document-export.sh
- [Authenticate to your 1Password account in the CLI](https://support.1password.com/command-line-getting-started/#get-started-with-the-command-line-tool)
- Once you have a valid CLI `op` session, run `./1password-document-export.sh` to get your documents

## Limitations

The Documents API does not return information about the file type, for some reason. The most useful fields in an export operation are the Document UUID and the Document Title, which is what this script uses. However, be aware that if you named one of your documents "My document" for example (i.e. without the extension), that will be the literal name of the exported file, and you will have to add the extension yourself.

Luckily, when you add a Document item to 1Password, the title is by default the complete file name you are uploading, so unless you changed item titles manually yourself, you should get the correct exported file name and extension in most cases.
