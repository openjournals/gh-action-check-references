require_relative "lib/paper_file"
require_relative "lib/doi_checker"

issue_id = ENV["ISSUE_ID"]

paper = PaperFile.find(".")
system("echo 'PAPER FOUND: #{paper.paper_path}'")
entries = paper.bibtex_entries unless paper.bibtex_error

if paper.bibtex_error
  error_msg = "Checking the BibTeX entries failed with the following error: \n```\n#{paper.bibtex_error}\n```"

  File.open("bibtex-summary.txt", "w") do |f|
    f.write error_msg
  end
else
  doi_summary = DOIChecker.new(entries).check_dois

  doi_pretty_list=""
  doi_summary.each do |type, messages|
    doi_pretty_list += "\n#{type.to_s.upcase} DOIs\n\n"
    if messages.empty?
      doi_pretty_list += "- None\n"
    else
      messages.each do |message|
        doi_pretty_list += "- #{message}\n"
      end
    end
  end

  bibtex_entries_info = <<~BIBTEXENTRIESINFO
    ```
    Reference check summary (note 'MISSING' DOIs are suggestions that need verification):
    #{doi_pretty_list}
    ```
  BIBTEXENTRIESINFO

  File.open("bibtex-summary.txt", "w") do |f|
    f.write bibtex_entries_info
  end
end


system("gh issue comment #{issue_id} --body-file bibtex-summary.txt")
