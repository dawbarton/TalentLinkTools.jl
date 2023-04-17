module TalentLinkTools

using PDFIO: pdDocOpen, pdDocGetPageCount, pdDocGetPage, pdPageExtractText, pdDocClose
using Tables: Tables
using CSV: write
using Ghostscript_jll: gs

export get_candidates, export_candidate_list, extract_candidate_pdf

function is_candidate_start(str)
    return occursin(r"^\s*\d+\.+(?:AACCAADD  |ACAD )(?:iinntteerrnnaall  |internal )?(?:PPIIFF,,  bbyy  |PIF, by )", str)
end

function get_match(field, str)
    re = Regex("\\s$field\\s+(.*)")
    m = match(re, str)
    if m === nothing
        return missing
    else
        return m.captures[1]
    end
end

mutable struct Candidate
    title::Union{Missing, String}
    forename::Union{Missing, String}
    surname::Union{Missing, String}
    email::Union{Missing, String}
    page_start::Union{Missing, Int}
    page_end::Union{Missing, Int}
end

Candidate() = Candidate(missing, missing, missing, missing, missing, missing)

Tables.rowaccess(::Type{Vector{Candidate}}) = true
Tables.rows(candidates::Vector{Candidate}) = candidates

function get_candidate(str)
    title = get_match("Title", str)
    forename = get_match("First Name", str)
    surname = get_match("Last Name", str)
    email = get_match("Email Address", str)
    return Candidate(title, forename, surname, email, missing, missing)
end

function get_candidates(src)
    doc = pdDocOpen(src)
    npage = pdDocGetPageCount(doc)
    candidates = Vector{Candidate}()
    first_candidate = true
    candidate = Candidate()
    for i in 1:npage
        page = pdDocGetPage(doc, i)
        io = IOBuffer()
        try # malformed pages are common unfortunately
            pdPageExtractText(io, page)
            str = String(take!(io))
            if is_candidate_start(str)
                next_candidate = get_candidate(str)
                if coalesce((candidate.title == next_candidate.title) &
                            (candidate.forename == next_candidate.forename) &
                            (candidate.surname == next_candidate.surname) &
                            (candidate.email == next_candidate.email), false) # same candidate - ignore (sometimes a duplicate page)
                    continue
                end
                if !first_candidate
                    candidate.page_end = i - 1
                    push!(candidates, candidate)
                else
                    first_candidate = false
                end
                candidate = next_candidate
                candidate.page_start = i
                @info "Page $i: $(candidate.forename) $(candidate.surname)"
            end
        catch e
            @warn "Caught exception" e
        end
    end
    if !first_candidate
        candidate.page_end = npage
        push!(candidates, candidate)
    end
    pdDocClose(doc)
    return candidates
end

function export_candidate_list(candidates::Vector{Candidate}, dest)
    write(dest, candidates)
end

function export_candidate_list(src, dest)
    candidates = get_candidates(src)
    export_candidate_list(candidates, dest)
end

function extract_pages(src, dest, (startpage, endpage))
    if !((startpage isa Integer) && (endpage isa Integer))
        throw(ArgumentError("startpage and endpage must be integers"))
    end
    if startpage < 1
        throw(ArgumentError("startpage must be >= 1"))
    end
    if endpage < startpage
        throw(ArgumentError("endpage must be >= startpage"))
    end
    run(`$(gs()) -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -dFirstPage=$(startpage) -dLastPage=$(endpage) "-sOutputFile=$(dest)" "$(src)"`)
end

function extract_candidate_pdf(src, dest, candidate::Candidate)
    extract_pages(src, dest, (candidate.page_start, candidate.page_end))
end

function extract_candidate_pdf(src, dest, candidates::Vector{Candidate})
    n = length(string(length(candidates)))
    for (i, candidate) in enumerate(candidates)
        extract_candidate_pdf(src, joinpath(dest, "$(lpad(i, n, "0"))-$(candidate.forename) $(candidate.surname).pdf"), candidate)
    end
end

function extract_candidate_pdf(src, dest)
    candidates = get_candidates(src)
    extract_candidate_pdf(src, dest, candidates)
end

end
