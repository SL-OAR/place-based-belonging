**Note:** Wordnet = adjacent (≤ 1 word apart) adjective-noun bigrams visualized as a network.  
These word nets show how words in the responses to "Why there?" are connected.

Line **thickness** represents **frequency** of co-occurrence.

If a word seems negatively valenced, it was very likely negated (e.g., preceded by the word "not").

**Generally**, US undergraduates of all years/cohorts (mostly 1st-through-4th-year and predominantly first-year)  
contributed data in `r ayrs_cam`. Because analyses combine data from multiple academic years,  
some students contributed data more than once.

**Across all places that were not subsequently aggregated into superordinate places  
and then disaggregated by subordinate places** (i.e., not Erb Memorial Union, Lokey Science Complex, or University Housing)  
**as well as across sentiments** (i.e., "belong" and "don't belong"),  
most students contributed to only one wave of data collection.

See [Supplemental Method](#supmeth){.color-#489D46} for more details.

Text data were annotated using the `udpipe` package.

Wordnet was generated using the `ggraph` and `igraph` packages.

Colors were produced using the `rocket` palette of the `viridis` package.
