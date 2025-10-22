## 1. CRRA_Research Objective

This repository replicates a **Constant Relative Risk Aversion (CRRA)** estimation exercise using experimental lottery choices. 

## 2. Structure 
| Folder | Description |
|--------|-------------|
| `data/raw` | Original input data (`new_data.dta`) |
| `data/processed` | Model outputs (`crra_results.csv`) |
| `code` | R scripts, including the main analysis RMarkdown (`result.Rmd`) |
| `docs` | Literature review and rendered PDF report |
| `analysis` | Notes |

## 3. Dataset descriptions

In this dataset, `id` represents the participant identifier. Each participant made 20 lottery choices. For each choice, they faced a lottery that yields either `lottery_hi` or `lottery_lo` with equal (50%) probability, or they could choose a sure payment of 10 yuan. If a participant chose the lottery, the variable choice is coded as 1.

## 4. Project Body Summaries
- [Literature review summary](docs/literature_review/literature_review.md)
- [Project code](code/result.Rmd)
- [CRRA Results](docs/result.pdf)

 