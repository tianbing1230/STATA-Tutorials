# Stata Tutorial

Teaching materials for a Stata tutorial.

## Folder Structure

- `lecture_slides/`  
  Tutorial chapter PDFs (PDF versions only).
- `assignment/`  
  Assignment PDF.
- `codes/`  
  Stata `.do` scripts for tutorial sessions.
- `data/`  
  Data processing script(s).
- `output/`  
  Generated output files (ignored by git except `.gitkeep`).

## Quick Start

1. Open Stata and set working directory to this repository root.
2. Review tutorial materials in `lecture_slides/`.
3. Run scripts from `codes/`.
4. Outputs will be written to `output/`.

## Current Coverage

This tutorial currently covers:

- Basic data handling and data workflow in Stata
- Core operations for data exploration and transformation
- Descriptive statistics

Content on inferential statistics and later modeling topics will be added in future updates.

## Data and Assignment Notes

### Data Notes

- All tutorial examples are based on **CPS 2010 individual data**.
- A **10% sample** was drawn and saved as **`cfps2010adult_10%.dta`** (the filename used in tutorial scripts).
- The sampled data were cleaned with the provided `.do` script(s), and **`cfps10_foruse.dta`** is used as the main tutorial demo dataset.
- Raw CFPS data are not distributed in this repository. Please download CFPS 2010 individual data yourself if needed.

### Assignment Notes

- This assignment requires the **CGSS 2003** dataset.
- The dataset is not included in this repository. Please download the CGSS 2003 data yourself before completing the assignment.
- If you need the assignment solutions, please contact the instructor.

### Lecture Slides Notes

- The PDFs in `lecture_slides/` were generated from LaTeX.
- Code for converting Stata output into LaTeX-callable content is provided at `lecture_slides/prep/OutputToLatex.do`.
- LaTeX compilation source files (`.tex`) are not included in this repository.
- If you need the LaTeX source files, please contact the instructor.

## Disclaimer

This repository is for educational purposes only.  
Materials, code, and examples are provided "as is" without warranty of any kind.  
Users are responsible for verifying results and complying with the original data providers' terms of use and licensing requirements.
