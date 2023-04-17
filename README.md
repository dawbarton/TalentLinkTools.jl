# TalentLinkTools

[![ColPrac: Contributor's Guide on Collaborative Practices for Community Packages](https://img.shields.io/badge/ColPrac-Contributor's%20Guide-blueviolet)](https://github.com/SciML/ColPrac)

As part of interviewing new recruits, I get sent large, combined PDFs of CVs and supporting documentation generated from Lumesse TalentLink. Being a large PDF (usually 100s of pages), they are hard to navigate/process. As such, this utility tries to parse the PDF and generate a spreadsheet of candidate names/emails/page numbers. The page number information can then be used with other utilities, such as [GhostScript](https://www.ghostscript.com/), [qpdf](https://github.com/qpdf/qpdf) or [pdftk](https://www.pdflabs.com/tools/pdftk-the-pdf-toolkit/). (I've found that GhostScript usually works best with the malformed PDFs that I get sent.)

## Installation

This package is very niche and so not registered in the Julia General Registry. Instead, add via GitHub.

Either use the package manager command line: `] add https://github.com/dawbarton/TalentLinkTools.jl.git`

Or the API:

```julia
using Pkg: Pkg

Pkg.add("https://github.com/dawbarton/TalentLinkTools.jl.git")
```

I recommend that you install into a temporary environment rather than into your main environment. E.g., `] activate --temp` first.

## Example usage

### Extract candidate information and then save as both a spreadsheet

```julia
using TalentLinkTools

# Export all the information as a CSV file
export_candidate_list("source file.pdf", "candidate-list.csv")
```

### Extract candidate information and then save as individual PDFs

```julia
using TalentLinkTools

# Extract individual PDFs for everyone into the "candidates" folder (must exist already)
extract_candidate_pdf("source file.pdf", "candidates")
```

### Extract candidate information and then save as both a spreadsheet and individual PDFs

Extract candidate information once and then reuse in subsequent function calls.

```julia
using TalentLinkTools

# Get all candidates as a vector of Candidates (contains title, forename, surname, email, page start, page end)
candidates = get_candidates("source file.pdf")

# Export all the information as a CSV file
export_candidate_list(candidates, "candidate-list.csv")

# Extract individual PDFs for everyone into the "candidates" folder (must exist already)
extract_candidate_pdf("source file.pdf", "candidates", candidates)
```
