\name{renderMultiDocument}
\alias{renderMultiDocument}
\title{Render R Markdown in Multiple Output Formats}
\usage{
renderMultiDocument(
  rmd_input,
  report_format = c("HTML", "PDF"),
  make_draft_final = FALSE,
  cleanup_aux_files = TRUE,
  number_sections = TRUE,
  number_section_depth=3,
  convert_header_levels=c(5,6),
  toc = TRUE,
  toc_depth = 2,
  self_contained = TRUE,
  docx_self_contained = FALSE,
  dev="png",
  literasee_template = "sgp_report",
  html_template = "default",
  epub_template = "default",
  pdf_template = "default",
  html_css = "default",
  epub_css = "default",
  docx_css = "default",
  cover_img = NULL,
  add_cover_title = FALSE,
  bibliography = "default",
  csl = "default",
  md_extensions=NULL,
  pandoc_args = NULL,
  report_params=NULL,
  ...)
}
\arguments{
  \item{rmd_input}{Character. Input file. Must be an R Markdown (.Rmd) file located in the working directory (unless \code{make_draft_final = TRUE}).}
  \item{report_format}{Report output format(s) to convert Rmd file to. Pass a vector of format names to render multiple formats.
          Defaults to the two polished versions (\sQuote{HTML} and \sQuote{PDF}). The \sQuote{RMD} option allows the user to create
          an intermediate .Rmd file that can be edited, reviewed, etc. and then re-run to render other formats.  \sQuote{EPUB} and
          \sQuote{DOCX} are also available. MS Word DOCX is intended to be a draft-version document as it does not support many of
          the stylization features included in the other formats.}
  \item{make_draft_final}{Boolean. Defaults to \sQuote{FALSE}. Should a \sQuote{Draft} .Rmd document rendered with a previous call to
          \code{renderMultiDocument} with \code{report_format = 'RMD'} and saved to the \sQuote{Draft} directory be changed to the
          \sQuote{final draft} and used to render requested report formats?  If \sQuote{TRUE}, \code{rmd_input} should be the name of
          the draft document (e.g. \code{rmd_input = 'Draft/My_Report-Compiled_Draft.Rmd'}). All required .Rmd and assets will be copied
          to the main directory and renamed appropriately (e.g. \sQuote{My_Report-Final_Draft.Rmd}).}
  \item{cleanup_aux_files}{Boolean.  Defaults to TRUE to delete the intermediate markdown files and directories be upon successful completion.}
  \item{number_sections}{Boolean. Should sections, subsections, and subsubsections be numbered.  Default \code{TRUE}}
  \item{number_section_depth}{Numeric. Depth of headers to include in section numbering. Default is 3 (subsubsections).}
  \item{convert_header_levels}{Numeric. Markdown header levels 5 and 6 can be used as figure captions in HTML document.
          These headers are converted back to in image captions for PDF format.}
  \item{toc}{Boolean. \code{TRUE} to include a table of contents in the output}
  \item{toc_depth}{Numeric. Depth of headers to include in table of contents. Default is 2 (subsections).}
  \item{self_contained}{Produce a standalone HTML file with no external dependencies, using data: URIs to incorporate the
          contents of linked scripts, stylesheets, images, and videos.}
  \item{docx_self_contained}{Produce a standalone DOCX file with no external dependencies.  Allows copy and paste of HTML content
          to Word document without serving the local directory.}
  \item{dev}{Graphics device to use for figure output (defaults to png).}
  \item{literasee_template}{Name of Literasee package style templates to use for rendering. Default is \sQuote{sgp_report}
          (currently the only option available).  Located at \code{system.file('rmarkdown', 'templates', 'sgp_report', 'resources', package = 'Literasee')}.
          Note that alternative templates must adopt the same naming conventions (\sQuote{html_report.html}, \sQuote{pdf_report.tex}, etc).}
  \item{html_template}{Pandoc template to use for HTML rendering. Pass \sQuote{default} to use the Literasee package default template.
          Note that if you do not use the default template then the features of \code{multi_document} will not be available.  Additionally,
          there is a \code{'simple'} version that does not include the table of contents or the two-toned background (useful for printing/PDF via browser).}
  \item{epub_template}{Pandoc template to use for EPUB rendering. The default uses the Pandoc base template.}
  \item{pdf_template}{Pandoc template to use for PDF rendering. Pass \sQuote{default} to use the Literasee package default template.}
  \item{html_css}{The CSS for HTML format if other than the default within the package.}
  \item{epub_css}{The CSS for EPUB format if other than the default within the package.}
  \item{docx_css}{The CSS for DOCX format if other than the default within the \code{Grmd} package.}
  \item{cover_img}{Directory path for image to use for cover to EPUB document.}
  \item{add_cover_title}{EXPERIMENTAL.  Add the document title and subtitle to the EPUB cover image. Currently set up for only .jpg files and
          tailored to an image with dimensions roughly 2100 x 2800.}
  \item{bibliography}{The LaTeX style bibliography file (.bib, .bibtex, etc.) to include. The default file included
          in the package includes references often used by the author and will likely be insufficient for most users.}
  \item{csl}{The CSL (citation style language) to use to format bibliography (if included).  Defaults to APA 5th edition. See
          \href{https://github.com/citation-style-language/styles}{this Github repository} for alternatives.  If NULL pandoc defaults will be used.}
  \item{md_extensions}{Markdown extensions to be added or removed from the default definition or R Markdown.}
  \item{pandoc_args}{Additional command line options to pass to pandoc}
  \item{report_params}{Additional report parameters to pass to \code{\link[rmarkdown]{render}} (\sQuote{params}).}
  \item{...}{Passed onto \code{\link{multi_document}} and/or \code{\link[rmarkdown]{html_document}}.}
}
\value{
  The compiled documents are written into the working directory.  Additional directories are created for each of the output formats.
}
\description{
Render the input file to the specified output formats using pandoc. If the input requires knitting then \code{\link[knitr:knit]{knit}} is called prior to pandoc.
}
\details{
This function is a wrapper function that combines calls to \code{\link[rmarkdown]{render}} and direct \code{system} calls to Pandoc.
The function typically begins with a rendering of the HTML version of the document and saves the markdown file from this rendering and uses that
as a base from which other formats can be rendered.  Other formats require specific post-processing, which is also accomplished in the function.
The \sQuote{RMD} \code{report_format} produces a knitted (\link[knitr:knit]{knit}) Rmarkdown file with all analyses, tables, plots, etc. calculated,
and can be useful in editing and proofing a document when using children.  The output (named as the rmd_input with \sQuote{-Compiled_Draft.Rmd})
can subsequently be re-rendered with \code{renderMultiDocument} and the various other \code{report_format} versions to produce polished documents.
}
\seealso{
\href{http://rmarkdown.rstudio.com/}{Rmarkdown}
\link[knitr:knit]{knit}, \link[rmarkdown]{render},
\href{http://johnmacfarlane.net/pandoc}{pandoc}
}
\examples{
\dontrun{
library(Literasee)

# Render all four polished document formats.
# Use --webtex to process LaTeX style math equations.

renderMultiDocument("My_Report.Rmd",
                    report_format = c("HTML", "EPUB", "PDF", "DOCX"),
                    cleanup_aux_files = FALSE,
                    pandoc_args = "--webtex")

}
\dontrun{
library(Literasee)

# Render RMD draft, edit output, and then
# re-render two polished document formats.

renderMultiDocument(rmd_input = "My_Report.Rmd",
                    report_format = "RMD")

#  Make edits to 'Draft/My_Report-Compiled_Draft.Rmd'. Set working
#  directory to 'Draft' and render HTML and PDF of edited version.

setwd("Draft")
renderMultiDocument(rmd_input = "My_Report-Compiled_Draft.Rmd",
                    report_format = c("HTML", "PDF"),
                    pandoc_args = "--webtex",
                    cleanup_aux_files=FALSE)

#  Make FINAL edits to 'Draft/My_Report-Compiled_Draft.Rmd'. Set working
#  directory to main directory and render HTML and PDF 'Final Draft' versions.

setwd("..")
renderMultiDocument(rmd_input = "Draft/My_Report-Compiled_Draft.Rmd",
                    report_format = c("HTML", "PDF"),
                    make_draft_final = TRUE,
                    pandoc_args = "--webtex")

}
}
\author{
Adam Van Iwaarden
}
