module Oura

using Dates
using HTTP
using JSON3

export OuraClient
export get_personal_info, get_oura_data
export sleep_report, readiness_report, activity_report
export get_scores

mutable struct OuraClient
    personal_token::String
end


const API_URL = "https://api.ouraring.com/"

function make_header(oura::OuraClient, kwargs...)
    headers = Dict("Authorization" => "Bearer $(oura.personal_token)", kwargs...)

    return headers
end

function make_url(endpoint::String)
    return API_URL * lstrip(endpoint, '/')
end

function get_personal_info(oura::OuraClient)
    url = make_url("v1/userinfo")
    headers = make_header(oura)
    resp = HTTP.get(url, headers)
    json_resp = JSON3.read(resp.body)

    return json_resp
end

function get_sleep_data(headers::Dict, params::Dict)
    url = make_url("v1/sleep")

    resp = HTTP.get(url, headers, query = params)
    json_resp = JSON3.read(resp.body)

    return json_resp[:sleep]
end

function get_readiness_data(headers::Dict, params::Dict)
    url = make_url("v1/readiness")

    resp = HTTP.get(url, headers, query = params)
    json_resp = JSON3.read(resp.body)

    return json_resp[:readiness]
end

function get_activity_data(headers::Dict, params::Dict)
    url = make_url("v1/activity")

    resp = HTTP.get(url, headers, query = params)
    json_resp = JSON3.read(resp.body)

    return json_resp[:activity]
end

function get_oura_data(oura::OuraClient; start_date::String, end_date::String, report_type::Symbol)
    headers = make_header(oura)
    params = Dict(:start => start_date, :end => end_date)
    if report_type == :sleep
        return get_sleep_data(headers, params)
    elseif report_type == :readiness
        return get_readiness_data(headers, params)
    elseif report_type == :activity
        return get_activity_data(headers, params)
    else
        error("Report type not recognized. Available types are [:sleep, :readiness, :activity]")
    end

end


include("analyze.jl")

end # module
