# CandidatePackTools

[![ColPrac: Contributor's Guide on Collaborative Practices for Community Packages](https://img.shields.io/badge/ColPrac-Contributor's%20Guide-blueviolet)](https://github.com/SciML/ColPrac)

As part of interviewing new recruits, I get sent large, combined PDFs of CVs and supporting documentation generated from Lumesse TalentLink. Being a large PDF (usually 100s of pages), they are hard to navigate/process. As such, this utility tries to parse the PDF and generate a spreadsheet of candidate names/emails/page numbers. The page number information can then be used with other utilities, such as [qpdf](https://github.com/qpdf/qpdf) or [pdftk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/).

## Example usage

```julia
using CandidatePackTools

export_candidates("source file.pdf", "destination file.csv")
```
