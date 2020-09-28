# Test (pls ignore)


```r
library(dplyr)
```

```
## 
## Attaching package: 'dplyr'
```

```
## The following objects are masked from 'package:stats':
## 
##     filter, lag
```

```
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
```

```r
mtcars %>% group_by(cyl) %>% summarise(mean(mpg))
```

```
## `summarise()` ungrouping output (override with `.groups` argument)
```

```
## # A tibble: 3 x 2
##     cyl `mean(mpg)`
##   <dbl>       <dbl>
## 1     4        26.7
## 2     6        19.7
## 3     8        15.1
```

