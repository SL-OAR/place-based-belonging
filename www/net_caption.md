# Emotion Caption

**Note:** Emotions are presented in rank order from most to least prevalent.

**Percentage** = the percentage of all eligible words classified as being representative of one of eight emotions 
(anger, anticipation, disgust, fear, joy, sadness, surprise, trust), based on  
[Plutchik's psychoevolutionary theory of emotion](https://doi.org/10.1177/053901882021004003)(#) ([Figure 1](#f1)(#}).

The threshold for the minimum number of responses was 20.

Because analyses combine data from multiple academic years, some students contributed data more than once.

<span style="color: #11E8FF; font-weight: bold;">Across all places that were not subsequently aggregated into superordinate places 
and then disaggregated by subordinate places</span> (i.e., not Erb Memorial Union, Lokey Science Complex, or University Housing)  
<span style="color: #11E8FF; font-weight: bold;">as well as across sentiments</span> (i.e., "belong" and "don't belong"), 
most students contributed to only one wave of data collection, relatively few students contributed to two waves, 
and no one contributed to three waves.

See [Supplemental Method](#supmeth)(#) for more details.

Text was annotated using the `tidytext` package.

The `nrc` lexicon ([Mohammad & Turney, 2013](https://arxiv.org/pdf/1308.6297.pdf)(#) was used to classify emotional content.

Bar plot was generated using the `ggplot2` package.

Colors were produced using the `rocket` palette of the `viridis` package.