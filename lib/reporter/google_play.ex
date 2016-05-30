defmodule Reporter.GooglePlay do
  use Timex
  defp droid_uri, do: Application.get_env(:reporter, :droid_uri, "https://play.google.com/store/getreviews")

  defp droid_query_string_params, do: "xhr=1&reviewSortOrder=0&reviewType=1"

  defp droid_details_uri, do: Application.get_env(:reporter, :droid_details_uri, "https://play.google.com/store/apps/details")


  @doc ~S"""
  Return list of class 'single-review'.

      iex> File.read!("./test/data/google_post.html") |> Floki.parse |> Enum.drop(1) |> Reporter.GooglePlay.reviews |> Enum.at(0)
      {"div", [{"class", "single-review"}],
      [{"a", [{"href", "/store/people/details?id=104642741116962989509"}],
        [{"img",
          [{"class", "author-image"},
           {"alt", "森本真治 avatar image"},
           {"src",
            "https://lh3.googleusercontent.com/uFp_tsTJboUY7kue5XAsGA=w48-c-h48"}],
          []}]},
       {"div",
        [{"class", "review-header"}, {"data-expand-target", ""},
         {"data-reviewid",
          "gp:AOqpTOG_ApTgL86SmNCfvsb9M_zf6KrN6SaZtJL40yOAD2GQxUzWS0XXjdEpOBsKHLMU1MHNj1Tfs27qlGN6GJw"}],
        [{"div", [{"class", "review-info"}],
          [{"span", [{"class", "author-name"}],
            [{"a",
              [{"href",
                "/store/people/details?id=104642741116962989509"}],
              ["森本真治"]}]},
           {"span", [{"class", "review-date"}], ["2015年6月20日"]},
           {"a",
            [{"class", "reviews-permalink"},
             {"href",
              "/store/apps/details?id=com.android.chromeu0026amp;reviewId=Z3A6QU9xcFRPR19BcFRnTDg2U21OQ2Z2c2I5TV96ZjZLck42U2FadEpMNDB5T0FEMkdReFV6V1MwWFhqZEVwT0JzS0hMTVUxTUhOajFUZnMyN3FsR042R0p3"},
             {"title", "このレビューへのリンクです"}], []},
           {"div",
            [{"class", "review-source"}, {"style", "display:none"}], []},
           {"div", [{"class", "review-info-star-rating"}],
            [{"div",
              [{"class", "tiny-star star-rating-non-editable-container"},
               {"aria-label",
                "5つ星のうち1つ星で評価しました"}],
              [{"div",
                [{"class", "current-rating"}, {"style", "width: 20%;"}],
                []}]}]}]},
         {"div", [{"class", "rate-review-wrapper"}],
          [{"div",
            [{"class", "play-button icon-button small rate-review"},
             {"title", "スパムとして報告します"},
             {"data-rating", "SPAM"}],
            [{"div", [{"class", "icon spam-flag"}], []}]},
           {"div",
            [{"class", "play-button icon-button small rate-review"},
             {"title", "役に立ったことを報告します"},
             {"data-rating", "HELPFUL"}],
            [{"div", [{"class", "icon thumbs-up"}], []}]},
           {"div",
            [{"class", "play-button icon-button small rate-review"},
             {"title",
              "役に立たなかったことを報告します"},
             {"data-rating", "UNHELPFUL"}],
            [{"div", [{"class", "icon thumbs-down"}], []}]}]}]},
       {"div", [{"class", "review-body"}],
        [{"span", [{"class", "review-title"}], ["不具合多すぎ"]},
         " 戻るがきかない、軽いのがうりなのにどんどん重くなるなど微妙につかえないブラウザになってます…数ヶ月まったく治らないのでいい加減見限ろうかと。 ",
         {"div", [{"class", "review-link"}, {"style", "display:none"}],
          [{"a",
            [{"class", "id-no-nav play-button tiny"}, {"href", "#"},
             {"target", "_blank"}], ["全文を表示"]}]}]}]}

  """
  @spec reviews(String.t) :: String.t
  def reviews(parsed_html), do: Floki.find(parsed_html, ".single-review")

  @doc ~S"""
  Return list of review infos.

  ## Example

      iex> File.read!("./test/data/google_post.html") |> Floki.parse |> Enum.drop(1) |> Reporter.GooglePlay.review_infos |> Enum.at(3)
      {"div", [{"class", "review-info"}],
      [{"span", [{"class", "author-name"}],
        [{"a",
          [{"href", "/store/people/details?id=117395283570537705728"}],
          ["Kiriya Nachi"]}]},
       {"span", [{"class", "review-date"}], ["2015年6月20日"]},
       {"a",
        [{"class", "reviews-permalink"},
         {"href",
          "/store/apps/details?id=com.android.chromeu0026amp;reviewId=Z3A6QU9xcFRPSDFpVURHVWo1Q091QnlUS1RHcjdhWXZpWmJzczJ5eHc0c3BBZ2RHc1dtT3dIMFVZR1VuRjZlRTFnQWVfVjhCeU5qd191OUV1cmxETDg2bEtF"},
         {"title", "このレビューへのリンクです"}], []},
       {"div", [{"class", "review-source"}, {"style", "display:none"}],
        []},
       {"div", [{"class", "review-info-star-rating"}],
        [{"div",
          [{"class", "tiny-star star-rating-non-editable-container"},
           {"aria-label",
            "5つ星のうち2つ星で評価しました"}],
          [{"div",
            [{"class", "current-rating"}, {"style", "width: 40%;"}],
            []}]}]}]}
  """
  @spec review_infos(String.t) :: String.t
  def review_infos(parsed_html), do: Floki.find(parsed_html, ".review-info")


  @doc ~S"""
  Return summary of reviews as List.

      iex> File.read!("./test/data/google_post.html") |> Floki.parse  |> Enum.drop(1) |> Reporter.GooglePlay.review_summaries |> Enum.at(0)
      %{"date" => "2015年6月20日", "author" => "森本真治", "rating" => 1.0,
              "title" => "不具合多すぎ",
              "body" => " 戻るがきかない、軽いのがうりなのにどんどん重くなるなど微妙につかえないブラウザになってます…数ヶ月まったく治らないのでいい加減見限ろうかと。 "}

  """
  @spec review_summaries(String.t) :: String.t
  def review_summaries(parsed_html) do
    Floki.find(parsed_html, ".single-review")
    |> Enum.reduce([], fn(single, list) ->

      # TODO: arrange a bit
      # no name: {"span", [{"class", "author-name"}], ["  A Google User "]}
      # has name: {"span", [{"class", "author-name"}],
      #             [{"a", [{"href", "/store/people/details?id=113906718293225094082"}],
      #               ["Chris Kapia"]}]}
      {_, _, name} = Floki.find(single, ".author-name") |> Enum.at(0)
      case name do
        [pri_name] when is_tuple(pri_name) ->
          {_, _, name} = pri_name
        [_] ->
          name
      end

      {_, _, date} = Floki.find(single, ".review-date") |> Enum.at(0)

      {_, _, body} = Floki.find(single, ".review-body") |> Enum.at(0)
      {_, _, title} = Enum.at(body, 0)
      body = Enum.at(body, 1)

      {_, rating, _} = Floki.find(single, ".current-rating") |> Enum.at(0)
      {_, rating} = Enum.find(rating, fn x -> {type, _} = x; type == "style" end)
      rating = Regex.scan(~r/[0-9]+/, rating) |> List.flatten |> List.first |> String.to_integer
      rating = rating / 20

      result = Map.new
               |> Map.put("date", Enum.at(date, 0))
               |> Map.put("author", Enum.at(name, 0))
               |> Map.put("rating", rating)
               |> Map.put("title", Enum.at(title, 0))
               |> Map.put("body", body)

      inspect list
      List.insert_at(list, -1, result)
    end)
  end


  @doc ~S"""
  Return list of review body.

  ## Example

  iex> File.read!("./test/data/google_post.html") |> Floki.parse |> Enum.drop(1) |> Reporter.GooglePlay.review_bodies |> Enum.at(1)
  {"div", [{"class", "review-body"}],
  [{"span", [{"class", "review-title"}], ["Android5版"]},
   " なぜか「すべてのタブを閉じる」がありません。それ以外は満足です。 ",
   {"div", [{"class", "review-link"}, {"style", "display:none"}],
    [{"a",
      [{"class", "id-no-nav play-button tiny"}, {"href", "#"},
       {"target", "_blank"}], ["全文を表示"]}]}]}

  """
  @spec review_bodies(String.t) :: String.t
  def review_bodies(parsed_html), do: Floki.find(parsed_html, ".review-body")

  @doc ~S"""
  Return list of review body which exclude blank titles.

  ## Example

  iex> File.read!("./test/data/google_post.html") |> Floki.parse |> Enum.drop(1) |> Reporter.GooglePlay.review_body_list |> Enum.at(0)
  " 戻るがきかない、軽いのがうりなのにどんどん重くなるなど微妙につかえないブラウザになってます…数ヶ月まったく治らないのでいい加減見限ろうかと。 "

  """
  @spec review_body_list(String.t) :: String.t
  def review_body_list(parsed_html) do
    Floki.find(parsed_html, ".review-body")
    |> Enum.reduce([], fn({_, _, review}, list) ->
        case Enum.at(review, 1) do
          nil -> Enum.into([""], list)
          body -> Enum.into([body], list)
        end
      end)
  end


  @doc ~S"""
  Return list of review titles.

  ## Example

  iex> File.read!("./test/data/google_post.html") |> Floki.parse |> Enum.drop(1) |> Reporter.GooglePlay.review_titles |> Enum.at(0)
  {"span", [{"class", "review-title"}], ["不具合多すぎ"]}

  """
  @spec review_titles(String.t) :: String.t
  def review_titles(parsed_html), do: Floki.find(parsed_html, ".review-title")

  @doc ~S"""
  Return list of review titles which exclude blank titles.

  ## Example

  iex> File.read!("./test/data/google_post.html") |> Floki.parse |> Enum.drop(1) |> Reporter.GooglePlay.review_title_list
  ["不具合多すぎ",
  "Android5版",
  "開いていたタブが消える",
  "文字が見辛い",
  "サファリで開設しようとしても何もログインできない",
  "ブックマーク劣化…",
  "唯一使えるブラウザ",
  "ソースコード",
  "アプリ検索してもGoogle playに飛ばされない",
  "フリーズし過ぎ",
  "動き",
  "おかしい…",
  "タブ",
  "サクサク動く。",
  "なんというか…", "使えない",
  "ホーム", "？",
  "ゴミ",
  "開いたタブか・・・",
  "急に強制終了",
  "コピーできない",
  "タブの",
  "画像が表示されない",
  "いつまで経っても",
  "問題が発生したため終了します",
  "不具合?",
  "おい、おい、"]

  """
  @spec review_title_list(String.t) :: String.t
  def review_title_list(parsed_html) do
    Floki.find(parsed_html, ".review-title")
    |> Enum.reduce([], fn({_, _, review}, list) -> Enum.into(review, list) end)
  end

  @doc ~S"""
  Return POST message.

  ## Examples

    iex> Reporter.GooglePlay.review_url("com.android.chrome")
    "https://play.google.com/store/getreviews?id=com.android.chrome&xhr=1&reviewSortOrder=0&reviewType=1&pageNum=0&hl=en"

    iex> Reporter.GooglePlay.review_url("com.android.chrome", "jp")
    "https://play.google.com/store/getreviews?id=com.android.chrome&xhr=1&reviewSortOrder=0&reviewType=1&pageNum=0&hl=jp"

  """
  @spec review_url(String.t, String.t) :: String.t
  def review_url(droid_package, locale \\ "en"), do: droid_uri <> "?" <> params(droid_package, locale, droid_query_string_params)

  defp params(droid_package, locale \\ "en", query_string_params) do
    query_string_params = query_string_params <> "&pageNum=0"
    post_message(droid_package, locale, query_string_params)
  end


  @doc ~S"""
  Return POST message with paging.

  ## Examples

    iex> Reporter.GooglePlay.review_url_with_page("com.android.chrome", "1")
    "https://play.google.com/store/getreviews?id=com.android.chrome&xhr=1&reviewSortOrder=0&reviewType=1&pageNum=1&hl=en"

    iex> Reporter.GooglePlay.review_url_with_page("com.android.chrome", "10" , "jp")
    "https://play.google.com/store/getreviews?id=com.android.chrome&xhr=1&reviewSortOrder=0&reviewType=1&pageNum=10&hl=jp"

  """
  @spec review_url_with_page(String.t, String.t, String.t) :: String.t
  def review_url_with_page(droid_package, page_num ,locale \\ "en") do
    droid_uri <> "?" <> params_with_page(droid_package, page_num, locale, droid_query_string_params)
  end

  def params_with_page(droid_package, page_num, locale \\ "en", query_string_params \\ "") do
    query_string_params = query_string_params <> "&pageNum=#{page_num}" <> "&" <> cache_buster_query_param
    post_message(droid_package, locale, query_string_params)
  end

  defp cache_buster_query_param do
    {:ok, date} = DateTime.local |> Timex.format("{ISO}")
    "current_date_time=" <> date
  end

  defp post_message(droid_package, locale, query_string_params) do
    Enum.join([
      "id=",
      droid_package,
      "&hl=",
      locale,
      "&",
      query_string_params
      ]
    ) |> URI.encode
  end

  def params_for_details(droid_package, locale \\ "en") do
    post_message(droid_package, locale, "")
  end

  def app_name(parsed_html) do
    Floki.find(parsed_html, ".id-app-title") |> List.first |> elem(2) |> List.first
  end

  def app_details(droid_package, locale \\ "en") do
    droid_details_uri <> "?" <> params_for_details(droid_package, locale)
  end

  def app_version(parsed_html) do
    Floki.find(parsed_html, ".content[itemprop=softwareVersion]") |> List.first |> elem(2) |> List.first |> String.strip
  end

  def app_image_url(parsed_html) do
    Floki.find(parsed_html, ".cover-image") |> List.first |> elem(1) |> Enum.drop(1) |> List.first |> elem(1) |> String.replace("//", "http://")
  end

end
