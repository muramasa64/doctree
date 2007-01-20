日付を解析します。

= module ParseDate

== Module Functions

--- parsedate(str, complete = false)
str で与えられた日付表現を解析し、見いだした要素を
配列 (年、月、日、時、分、秒、タイムゾーン、曜日) で返します。

complete が真で、年が0から99の範囲であれば、
年の下2桁の表現であるとみなし上2桁を補います。
69 以上なら 1900 年代とみなします。
69 未満なら 2000 年代とみなします。

  require 'parsedate'

  ParseDate.parsedate('Sat Aug 28 21:45:09 1999')
      # => [1999, 8, 28, 21, 45, 9, nil, 6]

  ParseDate.parsedate('Saturday, 28-Aug-99 21:45:09 GMT')
      # => [99, 8, 28, 21, 45, 9, "GMT", 6]

  ParseDate.parsedate('99-08-28', true)
      # => [1999, 8, 28, nil, nil, nil, nil, nil]

  ParseDate.parsedate('01-08-28', true)
      # => [2001, 8, 28, nil, nil, nil, nil, nil]

parsedate はいろいろな書式をあつかえます。
たとえば、つぎのような表現を受けつけます。

  Sat
  Saturday
  1999-08-28
  21:45:09
  09:45:09 PM
  1999-08-28T21:45:09+0900
  19990828 214509
  H11.08.28T21:45:09Z
  Sat Aug 28 21:45:09 1999
  Sat Aug 28 21:45:09 JST 1999
  Sat, 28 Aug 1999 21:45:09 -0400
  Saturday, 28-Aug-99 21:45:09 GMT
  08/28/1999
  1999/08/28

日付解析し直ちに [[c:Date]]、
あるいは [[c:DateTime]] オブジェクトを生成するには、
[[lib:date]] で提供される [[m:Date.parse]]、
[[m:DateTime.parse]] や [[m:Date.strptime]]、
[[m:DateTime.strptime]] などをつかうことができます。

日付解析し直ちに [[c:Time]] オブジェクトを生成するには、
[[lib:time]] で提供される [[m:Time.parse]] をつかうことができます。
