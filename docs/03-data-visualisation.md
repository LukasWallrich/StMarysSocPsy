# Data visualisation

Being able to look at the data is a key step in data exploration, during the analysis and in the communication of results. R has a range of powerful tools to create graphs quickly, and then to develop them into a publication-ready format where helpful.

[![](https://i1.pngguru.com/preview/158/556/881/tuts-icon-youtube-alt-png-clipart.jpg?display=inline-block){#id .class width=35 height=35px}](TK) &nbsp; For an introduction to the grammar of graphics and ggplot2, [watch/rewatch this video](https://youtu.be/sk7TT5qM5Hw)

## ggplot2

We use the `ggplot2`-package because it offers a consistent way to create anything from simple exploratory plots to complex data visualisation. Each graph command needs certain parts:

* a call to the `ggplot`-function and the **data** as the first argument: `ggplot(gapminder, `
* a mapping of the **aesthetics**, i.e. of variables to visual elements. This uses the `aes`-function that is given to `ggplot` as the second argument: `aes(x=infant_mortality, y=fertility, col=continent))` (Note that two closing brackets are needed as this also completes the ggplot function call)
* a **geometry**, i.e. a type of chart, that is added with a plus-symbol and the function call, e.g., ` + geom_point()`
* optional elements such as labels that are included again with plus-symbols and function calls, e.g., `+ ggtitle("Association of infant mortality and fertility", subtitle="2010 data from gapminder.org")`

Multiple geometries can be layered on top of each other, for example to add trend lines to scatterplots. In that case, `aes()` functions can be included into the `geom_()`-functions to make some of the mappings specific to certain geometries. This is done in the example below to color the points by continent without applying that aestethic to the line - if it was included in the main aes() function, the plot would contain a separate coloured line for each continent. 

*Note:* Line breaks are completely up to you and can be used to make the code readable as long as the command does not appear complete too early - to keep it simple, there should always be an open bracket, a comma or a + before a line break within the command to create a ggplot-chart


```r
library(dslabs)
gapminder2010 <- gapminder %>% filter(year==2010)

ggplot(gapminder2010, aes(x=infant_mortality, y=fertility)) +
  geom_point(aes(col=continent)) + geom_smooth() +
    ggtitle("Association of infant mortality and fertility", 
            subtitle="2010 data from gapminder.org")
```

```
## `geom_smooth()` using method = 'loess' and formula 'y ~ x'
```

```
## Warning: Removed 7 rows containing non-finite values (stat_smooth).
```

```
## Warning: Removed 7 rows containing missing values (geom_point).
```

<div class="figure" style="text-align: center">
<img src="03-data-visualisation_files/figure-html/unnamed-chunk-1-1.png" alt="**CAPTION THIS FIGURE!!**" width="100%" />
<p class="caption">(\#fig:unnamed-chunk-1)**CAPTION THIS FIGURE!!**</p>
</div>

## Further resources

* The [R Graphics Cookbook](https://r-graphics.org/) by Winston Chang is available online with 150 "recipes" that cover everything from basic exploratory charts to colour-coded maps.
* The BBC graphics team has published their own [R Cookbook](https://bbc.github.io/rcookbook/) with clear tips for making publishable charts that convey a clear message