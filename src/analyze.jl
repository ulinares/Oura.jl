function get_scores(report_response::AbstractArray)
    dates = Date.([item["summary_date"] for item in report_response], "y-m-d")
    scores = [get(item, "score", 0) for item in report_response]

    indices = sortperm(dates)
    dates = dates[indices]
    scores = scores[indices]

    return dates, scores
end
