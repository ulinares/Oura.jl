function get_date_metrics(report_response::AbstractArray, metric_name::String)
    dates = Date.([item["summary_date"] for item in report_response], "y-m-d")
    scores = [get(item, metric_name, 0) for item in report_response]

    indices = sortperm(dates)
    dates = dates[indices]
    scores = scores[indices]

    return dates, scores
end
