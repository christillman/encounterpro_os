# EncounterPro_OS
EncounterPro Open Source Electronic Health Record EHR/EMR and Physician Workflow

This repository contains the code and Markdown source files for [EncounterPro_OS](https://github.com/christillman/encounterpro_os).

## Contributing

[![Contributor Covenant](https://img.shields.io/badge/Contributor%20Covenant-2.1-4baaaa.svg)](code_of_conduct.md)

See [the contributing guide](CONTRIBUTING.md) for detailed instructions on how to get started with our project.

There are many ways of contributing, including some that don't require you to write a single line of code.

Open an issue using the most appropriate [issue template]() to describe the changes you'd like to see.

If you're looking for a way to contribute, you can scan through our [existing issues](https://github.com/christillman/encounterpro_os/issues) for something to work on. When ready, check out [Getting Started with Contributing](/CONTRIBUTING.md) for detailed instructions.

### Join us in discussions

Use our public Discussions page to talk about all sorts of topics related EncounterPro. For example: if you'd like help troubleshooting a PR, have a great new idea, or want to share something amazing you've learned in our docs, join us in the [discussions](https://github.com/christillman/encounterpro_os/discussions).

### Getting started

The [Release Notes](https://github.com/christillman/encounterpro_os/wiki/Release-Notes) for EncounterPro_OS are linked in the [Wiki homepage](https://github.com/christillman/encounterpro_os/wiki)

Use the latest binary installer to install the compiled EncounterPro. The installer is not released as part of source; it is available through [GreenOlive EHR](https://www.greenoliveehr.com/) which supports usage of EncounterPro_OS in clinician's offices. The SQL Server name will be 

localhost\encounterpro_os

and the tables are in the dbo schema.

### IDE / application development notes

To start using the application after a full install, you can use the PIN (access code) 0222. 
In the data (c_user) this is Dr. Pat Pedia's access code. You need office ID 0001 in the startup
DB dialog. "encounterpro_os" is the database in that dialog.

For images to show when you're running in the IDE, you need to put the IconFiles image folder 
on your system path (I use the System control panel). You need to restart the IDE.

Attachment locations are in c_Attachment_Location. You'll need to populate a server and share. For
development, I use localhost and a file share named attachments.

UPDATE c_Attachment_Location 
SET attachment_server = 'localhost', attachment_share = 'attachments'
WHERE attachment_location_id = 2

## License

The code in this repository is licensed under the [GNU Affero General Public License v3.0 license](https://github.com/christillman/encounterpro_os/blob/master/LICENSE).

## Thanks :purple_heart:

Thanks for all your contributions and efforts towards improving EncounterPro. We thank you for being part of our :sparkles: community :sparkles:!



