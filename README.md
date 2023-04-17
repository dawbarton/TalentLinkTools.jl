# TalentLinkTools

[![ColPrac: Contributor's Guide on Collaborative Practices for Community Packages](https://img.shields.io/badge/ColPrac-Contributor's%20Guide-blueviolet)](https://github.com/SciML/ColPrac)

As part of interviewing new recruits, I get sent large, combined PDFs of CVs and supporting documentation generated from Lumesse TalentLink. Being a large PDF (usually 100s of pages), they are hard to navigate/process. As such, this utility tries to parse the PDF and generate a spreadsheet of candidate names/emails/page numbers. The page number information can then be used with other utilities, such as [GhostScript](https://www.ghostscript.com/), [qpdf](https://github.com/qpdf/qpdf) or [pdftk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/). (I've found that GhostScript usually works best with the malformed PDFs that I get sent.)

## Example usage

With Julia

```julia
using TalentLinkTools

export_candidates("source file.pdf", "destination file.csv")
```

Then with whatever tool you want, generate individual PDFs, e.g., with GhostScript

```bash
gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -dFirstPage=1 -dLastPage=20 "-sOutputFile=candidates/001-First Person.pdf" "Candidate_Pack ACAD12345678.pdf"
```
