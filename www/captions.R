## Captions ##

# output$CampusMapCaption <- renderUI({
#   HTML("<p><b>Note:</b> 
#   <b><span style='color: red;'>R</span>
#   <span style='color: orange;'>O</span>
#   <span style='color: yellow;'>Y</span>
#   <span style='color: #39FF14;'>G</span>
#   <span style='color: blue;'>B</span>
#   <span style='color: #4B0082;'>I</span>
#   <span style='color: violet;'>V</span></b> 
#   spectrum represents a continuum from more to fewer clicks on a place, given total number of clicks. 
#   Number of clicks on a place &ge; 20 are displayed.</p>
# 
# <p>Color saturation and area of blobs are dependent on concentration in a general area, irrespective of 
# regions drawn on a map, which can sometimes be inconsistent with quantification based on clicks in map regions.</p>
# 
# <p><b>\"All Years\"</b> = Mostly first-year, second-year, third-year, fourth-year, and fifth-year 
# (i.e., 2021-22, 2020-21, 2019-20, 2018-19, and 2017-18 cohorts, respectively) US undergraduates contributed data, 
# along with a few <i>n-year</i> students (i.e., a few from 2002-03, 2007-08, 2010-11, 2011-12, 2014-15, and 2016-17 cohorts) 
# and US exchange undergraduates.</p>
# 
# <p>See <a href='#supmeth' style='color: #DF63A4;'>Supplemental Method</a> for more details.</p>
# 
# <p>Heat map were originally produced in Qualtrics (30px radius, 35px blur) the click counts were overlaid on the heat map image 
# using the <code>magick</code> package. These are images of the maps created.</p>")
# })

# output$CampusTableCaption <- renderUI({
#   HTML("<p><b>Note:</b> All columns are sortable. The default sorting is alphabetical order of <b>Aggregated Place</b> then <b>Place</b>. 
# The <b>Aggregated Place</b> column is searchable. Scroll right to see more metrics on the right side of the table. 
# Use the \"Show\" dropdown to elongate the table up to 100 rows. Click \"Previous,\" \"Next,\" or numbers between to move through pages.</p>
# 
# <p>The table is hierarchically organized: <b>Place</b> within <b>Aggregated Place</b>. Click the triangle next to an <b>Aggregated Place</b> 
# to drop down its list of subordinate Places. Parentheses to the right of <b>Aggregated Place</b> names denote how many subordinate places 
# there are (1 = Aggregated Place and Place are identical).</p>
# 
# <p>An <b>Aggregated Place</b> combines places in the <b>Place</b> column that are spatial (e.g., Lokey Science Complex) or conceptual (e.g., 
# University Housing) clusters of many places. Most aggregation is based on campus maps, but the Erb Memorial Union has its own maps and data collection. 
# Consequently, the <b>\"Erb Memorial Union\"</b> entry in the <b>Aggregated Place</b> column contains campus-level data, and the 
# <b>\"EMU-Specific Places\"</b> entry contains EMU-level data.</p>
# 
# <p><span style='color: #11E8FF;'><b>Inclusive</b></span> is a percentage indicating how inclusive a place is and is computed by:  
# <i>n</i> Belong / (<i>n</i> Belong + <i>n</i> Don't Belong) * 100.</p>
# 
# <p><span style='color: #49C1AD; font-style: italic'>n</span> <span style='color: #11E8FF'>Belong</span> and 
# <span style='color: #49C1AD; font-style: italic'>n</span> <span style='color: #11E8FF'>Don't Belong</span> are raw counts of how many clicks 
# a place accrued on the \"belong\" map or \"don't belong\" map, respectively.</p>
# 
# <p><span style='color: #11E8FF;'><b>Click Belong</b></span> and <span style='color: #11E8FF;'><b>Click Don't Belong</b></span> are percentages indicating 
# the extent to which a place is considered somewhere students feel like they belong or don’t belong, respectively, relative to other places. 
# They are computed by dividing <i>n</i> Belong and <i>n</i> Don't Belong by the total number of Belong or Don't Belong clicks, respectively, and multiplying by 100.</p>
# 
# <p><span style='color: #11E8FF;'><b>Student Belong</b></span> and <span style='color: #11E8FF;'><b>Student Don't Belong</b></span> are percentages indicating 
# the extent to which students agree that a place is somewhere they feel they belong or don’t belong, respectively. 
# They are computed by dividing <i>n</i> Belong and <i>n</i> Don't Belong by the total numbers of students who contributed data to those <i>n</i>s, respectively.</p>
# 
# <p>In other words, <span style='color: #11E8FF;'><b>Inclusive</b></span>, <i>n</i> Belong, <i>n</i> Don't Belong, 
# <span style='color: #11E8FF;'><b>Click Belong</b></span>, and <span style='color: #11E8FF;'><b>Click Don't Belong</b></span> are all 
# <span style='color: #11E8FF;'><b>place-based metrics</b></span>, whereas <span style='color: #11E8FF;'><b>Student Belong</b></span> and 
# <span style='color: #11E8FF;'><b>Student Don't Belong</b></span> are <span style='color: #11E8FF;'><b>person-based metrics</b></span>.</p>
# 
# <p>Because this overall table combines data from multiple academic years and because both places and methods have changed over the years, 
# there is some inaccuracy in representing some places. For example:</p>
# 
# <ul>
#   <li><b>Unthank Hall</b> did not exist before Spring 2022 data collection, so its metrics are likely underestimated.</li>
#   <li><b>Lokey Science Complex</b> was disaggregated in map regions after Spring 2018. Thus, it appears as both an aggregated place and a subordinate 
#   place (Spring 2018) with legitimate subordinate places that make up Lokey Science Complex (Spring 2019, Spring 2020, Spring 2022).</li>
# </ul>
# 
# <p><b>Spring 2022:</b> Mostly first-year, second-year, third-year, fourth-year, and fifth-year (i.e., 2021-22, 2020-21, 2019-20, 2018-19, 
# and 2017-18 cohorts, respectively) US undergraduates contributed data, along with a few <i>n-year</i> students (i.e., a few from 2002-03, 
# 2007-08, 2010-11, 2011-12, 2014-15, and 2016-17 cohorts) and US exchange undergraduates. <b>East Lawn</b> was mislabeled as <b>West Lawn</b>, 
# meaning there is no distinction between them.</p>
# 
# <p><b>Spring 2020:</b> First-year, second-year, third-year, fourth-year, and fifth-year (i.e., 2019-20, 2018-19, 2017-18, 2016-17, and 
# 2015-16 cohorts, respectively) US undergraduates contributed data.</p>
# 
# <p><b>Spring 2019:</b> First-year, second-year, third-year, and fourth-year (i.e., 2018-19, 2017-18, 2016-17, and 2015-16 cohorts, respectively) 
# US undergraduates contributed data. <b>Baker</b> was mislabeled as <b>Barnhart</b>, meaning there is no distinction between them. 
# Additionally, no region was drawn for <b>Autzen Stadium</b>, so no click data exist for it.</p>
# 
# <p><b>Spring 2018:</b> First-year, second-year, and third-year (i.e., 2017-18, 2016-17, and 2015-16 cohorts, respectively) 
# US undergraduates contributed data.</p>")
# })


# output$EmuMapCaption <- renderUI({
#   HTML("<p><b>Note:</b> 
#   <b><span style='color: red;'>R</span>
#   <span style='color: orange;'>O</span>
#   <span style='color: yellow;'>Y</span>
#   <span style='color: #39FF14;'>G</span>
#   <span style='color: blue;'>B</span>
#   <span style='color: #4B0082;'>I</span>
#   <span style='color: violet;'>V</span></b> 
#   spectrum represents a continuum from more to fewer clicks on a place, given total number of clicks.</p>
# 
# <p>Number of clicks on a place &ge; 20 are displayed.</p>
# 
# <p>Color saturation and area of blobs are dependent on concentration in a general area, 
# irrespective of regions drawn on a map, which can sometimes be inconsistent with quantification based on clicks in map regions.</p>
# 
# <p><b>\"All Years\"</b> = Mostly first-year, second-year, third-year, fourth-year, and fifth-year 
# (i.e., 2021-22, 2020-21, 2019-20, 2018-19, and 2017-18 cohorts, respectively) US undergraduates contributed data, 
# along with a few <i>n-year</i> students (i.e., a few from 2002-03, 2007-08, 2010-11, 2011-12, 2014-15, and 2016-17 cohorts) 
# and US exchange undergraduates.</p>
# 
# <b>Additionally, the Erb Memorial Union map in Spring 2019 consisted of two vertically stacked images.</b> 
# This produces blob distortion across images, and it results in invalid data; 
# although students were instructed to select up to 3, some selected more than 3 places. 
# For quantification of maps and other analyses, the first three recorded responses from these few students were used and the rest were discarded.<br><br>
#     
# See <a href='#supmeth' style='color: #DF63A4'>Supplemental Method</a> for more details.
# Heat map was originally produced in Qualtrics (30px radius, 35px blur) then click counts were overlaid on the heat map image using the <code>magick</code> package.
#        These are images of the maps produced.</p>")
# })

# output$AggBarCaption <- renderUI({
#   HTML("Inclusiveness is a percentage indicating how inclusive a place is and is computed by:
#          <br>
#          <i>n</i> Belong / (<i>n</i> Belong + <i>n</i> Don't Belong) * 100.
#          <br><br>
#          <b>Yellow</b> represents the high end of the inclusiveness continuum, and <b>black</b> represents the low end.
#          Color mapping to inclusiveness percentages follows the treemaps in the 'Disaggregated and Less Delimited' section
#          and is thus variable across plots.
#          <br><br>
#          <b>'Aggregated'</b> = Some individual places were combined into larger places
#          (e.g., residence halls into University Housing).
#          <br>
#          <b>'More Delimited'</b> = The criterion for inclusion of a place in a plot was
#          &ge; 0.1 of the total proportion of clicks, where total proportion of clicks
#          was defined as the total number of clicks on a place divided by the
#          average of the total number of clicks across all places.
#          This is a stricter criterion than that used in 'Less Delimited.'
#          <br><br>
#          Clicks on Lawn, Other, and Out of Bounds regions were omitted before computing the total proportion of clicks.
#          <br><br>
#          <b>Spring 2022:</b>
#          Mostly first-year, second-year, third-year, fourth-year, and fifth-year
#          (i.e., 2021-22, 2020-21, 2019-20, 2018-19, and 2017-18 cohorts, respectively)
#          US undergraduates contributed data, along with a few n-year students
#          (i.e., from 2002-03, 2007-08, 2010-11, 2011-12, 2014-15, and 2016-17 cohorts)
#          and US exchange undergraduates.
#          <br><br>
#          <b>Spring 2020:</b>
#          First-year, second-year, third-year, fourth-year, and fifth-year
#          (i.e., 2019-20, 2018-19, 2017-18, 2016-17, and 2015-16 cohorts, respectively)
#          US undergraduates contributed data.
#          <br><br>
#          <b>Spring 2019:</b>
#          First-year, second-year, third-year, and fourth-year
#          (i.e., 2018-19, 2017-18, 2016-17, and 2015-16 cohorts, respectively)
#          US undergraduates contributed data.
#          <br><br>
#          <b>Spring 2018:</b>
#          First-year, second-year, and third-year
#          (i.e., 2017-18, 2016-17, and 2015-16 cohorts, respectively)
#          US undergraduates contributed data.
#        ")
# })

# output$DisaggTreeCaption <- renderUI({
#   HTML("Note: Rectangle <span style='color: #11E8FF'>size</span> represents a place's overall <span style='color: #11E8FF'>popularity</span>, 
#          computed by <i>n</i> Belong + <i>n</i> Don't Belong.
#          Rectangle <span style='color: #11E8FF'>color</span> represents a place's <span style='color: #11E8FF'>inclusiveness</span>,
#          which is a percentage indicating how inclusive a place is and is computed by:
#          <br>
#          <i>n</i> Belong / (<i>n</i> Belong + <i>n</i> Don't Belong) * 100.
#          <br><br>
#          <b>Yellow</b> represents the high end of the inclusiveness continuum, and <b>black</b> represents the low end.
#          <span style='color: gray;'>Gray text</span> represents inclusiveness &gt; 75%.
#          <br><br>
#          <b>'Disaggregated'</b> = Nothing was done to combine individual places into larger places
#          (e.g., residence halls into University Housing).
#          <b>'Less Delimited'</b> = The criterion for inclusion in a treemap was a total click count of at least 20,
#          which is less restrictive than the criterion used in 'More Delimited.'
#          The criterion for presenting a treemap was at least 4 places represented.
#          Additionally, all treemaps omit clicks on Lawn, Other, and Out of Bounds regions.
#          <br><br>
#          Some names of places with lower popularity were abbreviated to fit the text in their respective rectangles:
#          <br>
#          <span style='color: #11E8FF'><b>TF</b></span> = Turf Field,
#          <span style='color: #11E8FF'><b>DS</b></span> = Duck Store,
#          <span style='color: #11E8FF'><b>Barn</b></span> = Outdoor Program Barn,
#          <span style='color: #11E8FF'><b>Cas</b></span> = Cascade,
#          <span style='color: #11E8FF'><b>FAS</b></span> = Fine Art Studios,
#          <span style='color: #11E8FF'><b>MNL</b></span> = Many Nations Longhouse,
#          <span style='color: #11E8FF'><b>MS</b></span> = LERC Military Science,
#          <span style='color: #11E8FF'><b>MNCH</b></span> = Museum of Natural and Cultural History,
#          <span style='color: #11E8FF'><b>Moss</b></span> = Moss Street Children's Center,
#          <span style='color: #11E8FF'><b>Fent</b></span> = Fenton,
#          <span style='color: #11E8FF'><b>LLC</b></span> = Living Learning Center,
#          <span style='color: #11E8FF'><b>Essl</b></span> = Esslinger,
#          <span style='color: #11E8FF'><b>BCC</b></span> = Black Cultural Center,
#          <span style='color: #11E8FF'><b>Mac</b></span> = McArthur Court,
#          <span style='color: #11E8FF'><b>Saun Stad</b></span> = Saunders Stadium,
#          <span style='color: #11E8FF'><b>Friend</b></span> = Friendly,
#          <span style='color: #11E8FF'><b>TI</b></span> = Tennis Indoor,
#          <span style='color: #49C1AD'><b>PLC</b></span> = Prince Lucien Campbell.
#          <br><br>
#          Because this overall treemap combines data from multiple academic years,
#          and because both places and methods have changed over time,
#          there is some inaccuracy in representing popularity and inclusiveness
#          (treemaps within academic years are accurate; however,
#          due to limited data, the overall treemap for international students remains accurate despite combining data).
#          <br><br>
#          For example, Unthank Hall did not exist before Spring 2022 data collection,
#          and Lokey Science Complex was disaggregated in map regions after Spring 2018.
#          Thus, Unthank's popularity is likely underestimated,
#          and its inclusiveness may be as well.
#          Lokey Science Complex (Spring 2018) is depicted on the treemap along with its disaggregated components from later years.
#          <br><br>
#          <b>Spring 2022:</b>
#          Mostly first-year, second-year, third-year, fourth-year, and fifth-year
#          (i.e., 2021-22, 2020-21, 2019-20, 2018-19, and 2017-18 cohorts, respectively)
#          US undergraduates contributed data, along with a few n-year students
#          (i.e., from 2002-03, 2007-08, 2010-11, 2011-12, 2014-15, and 2016-17 cohorts) and US exchange undergraduates.
#          <br>
#          <span style='color: red;'><b>East Lawn was mislabeled as West Lawn</b></span>.
#          There is no distinction between East and West Lawns.
#          <br><br>
#          <b>Spring 2020:</b>
#          First-year, second-year, third-year, fourth-year, and fifth-year
#          (i.e., 2019-20, 2018-19, 2017-18, 2016-17, and 2015-16 cohorts, respectively)
#          US undergraduates contributed data.
#          <br><br>
#          <b>Spring 2019:</b>
#          First-year, second-year, third-year, and fourth-year
#          (i.e., 2018-19, 2017-18, 2016-17, and 2015-16 cohorts, respectively)
#          US undergraduates contributed data.
#          <br>
#          <span style='color: red;'><b>Baker was mislabeled as Barnhart</b></span>.
#          There is no distinction between Baker and Barnhart.
#          Additionally, no region was drawn for Autzen Stadium;
#          therefore, no click data exist for Autzen.
#          <br><br>
#          <b>Spring 2018:</b>
#          First-year, second-year, and third-year
#          (i.e., 2017-18, 2016-17, and 2015-16 cohorts, respectively)
#          US undergraduates contributed data.")
# }
# )

# output$EmuTreeCaption <- renderUI({
#   HTML("Note: Rectangle <span style='color: #11E8FF'>size</span> represents a place's overall <span style='color: #11E8FF'>popularity</span>,
#          computed by <i>n</i> Belong + <i>n</i> Don't Belong.
#          <br>
#          Rectangle <span style='color: #11E8FF'>color</span> represents a place's <span style='color: #11E8FF'>inclusiveness</span>,
#          which is a percentage indicating how inclusive a place is and is computed by:
#          <br>
#          <i>n</i> Belong / (<i>n</i> Belong + <i>n</i> Don't Belong) * 100.
#          <br><br>
#          <b>Yellow</b> represents the high end of the inclusiveness continuum, and <b>black</b> represents the low end.
#          <span style='color: gray;'>Gray text</span> represents inclusiveness &gt; 75%.
#          <br><br>
#          The criterion for inclusion of a place in the treemap was a total click count of at least 20.
#          The criterion for presenting a treemap was at least 4 places represented.
#          Additionally, all treemaps omit clicks on 'Other' and 'Out of Bounds' regions.
#          <br><br>
#          <b>Abbreviations:</b>
#          <b>SSC</b> = Student Sustainability Center
#          <b>Hallway 1</b> = The East wing hallway on level 1 that runs in front of the Multicultural Center
#          <b>Hallway 2</b> = The East wing hallway on level 2 that runs in front of the Center for Student Involvement Resource Center and the Redwood Auditorium
#          <br><br>
#          Because this overall treemap combines data from multiple academic years,
#          and because both places and methods have changed over time,
#          there is some inaccuracy in representing popularity and inclusiveness
#          (treemaps within academic years are accurate).
#          <br><br>
#          <b>Spring 2022:</b>
#          Mostly first-year, second-year, third-year, fourth-year, and fifth-year
#          (i.e., 2021-22, 2020-21, 2019-20, 2018-19, and 2017-18 cohorts, respectively)
#          US undergraduates contributed data, along with a few n-year students
#          (i.e., from 2002-03, 2007-08, 2010-11, 2011-12, 2014-15, and 2016-17 cohorts)
#          and US exchange undergraduates.
#          <br><br>
#          <b>Spring 2020:</b>
#          First-year, second-year, third-year, fourth-year, and fifth-year
#          (i.e., 2019-20, 2018-19, 2017-18, 2016-17, and 2015-16 cohorts, respectively)
#          US undergraduates contributed data.
#          <br><br>
#          <b>Spring 2019:</b>
#          First-year, second-year, third-year, and fourth-year
#          (i.e., 2018-19, 2017-18, 2016-17, and 2015-16 cohorts, respectively)
#          US undergraduates contributed data.
#          <br><br>
#          <b>Spring 2018:</b>
#          First-year, second-year, and third-year
#          (i.e., 2017-18, 2016-17, and 2015-16 cohorts, respectively)
#          US undergraduates contributed data.")
# }
# )

# output$CloudCaption <- renderUI({
#   HTML("<p><b>Note:</b> Word <span style='color: #11E8FF; font-weight: bold;'>size</span> represents 
# <span style='color: #11E8FF; font-weight: bold;'>frequency</span> of keyword occurrence.</p>
# 
# <p><span style='color: #11E8FF; font-weight: bold;'>Hover over</span> words to see frequencies.</p>
# 
# <p>The criterion for inclusion of a keyword in the wordcloud was occurrence &gt; 1.</p>
# 
# <p>If a word seems negatively valenced, it was very likely negated (e.g., preceded by the word \"not\").</p>
# 
# <p>Because analyses combine data from multiple academic years, some students contributed data more than once.</p>
# 
# <p><span style='color: #11E8FF; font-weight: bold;'>Across all places that were not subsequently aggregated 
# into superordinate places and then disaggregated by subordinate places</span> 
# (i.e., not Erb Memorial Union, Lokey Science Complex, or University Housing) 
# <span style='color: #11E8FF; font-weight: bold;'>as well as across sentiments</span> 
# (i.e., \"belong\" and \"don't belong\"), most students contributed to only one wave of data collection, 
# relatively few students contributed to two waves, and no one contributed to three waves.</p>
# 
# <p>See <a href='#supmeth' style='color: #DF63A4'>Supplemental Method</a> for more details.</p>
# 
# <p>Text data were annotated using the <code>udpipe</code> package.</p>
# 
# <p>Keywords were extracted using the <b>Rapid Keyword Extraction (RAKE) algorithm</b> 
# (<a href='https://uoregon-my.sharepoint.com/:b:/g/personal/clark13_uoregon_edu/Eda0fgvF1VJAn2PPEU3c0xIBTrkNJIEnzOUzQhz6zaT5IA?e=FeHDYB' target='_blank' style='color: #DF63A4;'>Rose et al., 2010</a>).</p>
# 
# <p>Wordcloud was generated using the <code>wordcloud2</code> package.</p>
# 
# <p>Colors were produced using the <code>rocket</code> palette of the <code>viridis</code> package.</p>")
# })

# output$NetCaption <- renderUI({
#   HTML("<p><b>Note:</b> Wordnet = adjacent (&le; 1 word apart) adjective-noun bigrams visualized as a network.</p>
# 
# <p>Line <span style='color: #11E8FF; font-weight: bold;'>thickness</span> represents 
# <span style='color: #11E8FF; font-weight: bold;'>frequency</span> of co-occurrence.</p>
# 
# <p>If a word seems negatively valenced, it was very likely negated (e.g., preceded by the word \"not\").</p>
# 
# <p><span style='color: #11E8FF; font-weight: bold;'>Generally</span>, 
# US undergraduates of all years/cohorts (mostly 1st-through-4th-year and predominantly first-year) 
# contributed data in <code>r ayrs_cam</code>. Because analyses combine data from multiple academic years, 
# some students contributed data more than once.</p>
# 
# <p><span style='color: #11E8FF; font-weight: bold;'>Across all places that were not subsequently 
# aggregated into superordinate places and then disaggregated by subordinate places</span> 
# (i.e., not Erb Memorial Union, Lokey Science Complex, or University Housing) 
# <span style='color: #11E8FF; font-weight: bold;'>as well as across sentiments</span> 
# (i.e., \"belong\" and \"don't belong\"), most students contributed to only one wave of data collection.</p>
# 
# <p>See <a href='#supmeth' style='color: #DF63A4'>Supplemental Method</a> for more details.</p>
# 
# <p>Text data were annotated using the <code>udpipe</code> package.</p>
# 
# <p>Wordnet was generated using the <code>ggraph</code> and <code>igraph</code> packages.</p>
# 
# <p>Colors were produced using the <code>rocket</code> palette of the <code>viridis</code> package.</p>")
# })

# output$EmotionCaption <- renderUI({
#   HTML("<p><b>Note:</b> Emotions are presented in rank order from most to least prevalent.</p>
# 
# <p><b>Percentage</b> = the percentage of all eligible words classified as being representative of one of eight emotions
# (anger, anticipation, disgust, fear, joy, sadness, surprise, trust), based on
# <a href='https://doi.org/10.1177/053901882021004003' target='_blank' style='color: #DF63A4;'>Plutchik's psychoevolutionary theory of emotion</a>
# (<a href='#f1' style='color: #DF63A4;'>Figure 1</a>).</p>
# 
# <p>The threshold for the minimum number of responses was 20.</p>
# 
# <p>Because analyses combine data from multiple academic years, some students contributed data more than once.</p>
# 
# <p><span style='color: #11E8FF; font-weight: bold;'>Across all places that were not subsequently aggregated into superordinate places
# and then disaggregated by subordinate places</span> (i.e., not Erb Memorial Union, Lokey Science Complex, or University Housing)
# <span style='color: #11E8FF; font-weight: bold;'>as well as across sentiments</span> (i.e., \"belong\" and \"don't belong\"),
# most students contributed to only one wave of data collection, relatively few students contributed to two waves,
# and no one contributed to three waves.</p>
# 
# <p>See <a href='#supmeth' style='color: #DF63A4;'>Supplemental Method</a> for more details.</p>
# 
# <p>Text was annotated using the <code>tidytext</code> package.</p>
# 
# <p>The <code>nrc</code> lexicon
# (<a href='https://arxiv.org/pdf/1308.6297.pdf' target='_blank' style='color: #DF63A4;'>Mohammad & Turney, 2013</a>)
# was used to classify emotional content.</p>
# 
# <p>Bar plot was generated using the <code>ggplot2</code> package.</p>
# 
# <p>Colors were produced using the <code>rocket</code> palette of the <code>viridis</code> package.</p>")
# })