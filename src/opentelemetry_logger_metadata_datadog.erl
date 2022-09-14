-module(opentelemetry_logger_metadata_datadog).

-export([
    setup/0,
    filter/2,
    trace_id_to_dd/1
]).

-include_lib("opentelemetry_api/include/opentelemetry.hrl").

-spec setup() -> ok.
setup() ->
    logger:add_primary_filter(opentelemetry_logger_metadata_datadog, {fun filter/2, []}),
    ok.

span_id_to_dd(HexVal) ->
    SpanId = binary_to_list(HexVal),
    Int = list_to_integer(SpanId, 16),
    integer_to_binary(Int).

% Translate a OTLP Trace ID into a datadog friendly trace id. 
% recreating the behavior of the the DataDog-Agent implementation:
% https://github.com/DataDog/datadog-agent/blob/f33d8f00422e4a064d467077879f4301ecd62a46/pkg/trace/api/otlp.go#L639-L641
trace_id_to_dd(HexTraceId) ->
    TraceSlice = binary:part(HexTraceId, {byte_size(HexTraceId), -16}),
    TraceList = binary_to_list(TraceSlice),
    Int = list_to_integer(TraceList, 16),
    integer_to_binary(Int).

filter(LogEvent, _Config) ->
    case otel_tracer:current_span_ctx() of
        undefined ->
            ignore;
        SpanCtx ->
            HexTraceId = otel_span:hex_trace_id(SpanCtx),
            HexSpanId = otel_span:hex_span_id(SpanCtx),
            TraceId = trace_id_to_dd(HexTraceId),
            SpanId = span_id_to_dd(HexSpanId),

            #{meta := Meta} = LogEvent,
            TraceInformation = #{trace_id => TraceId, span_id => SpanId},
            MetaWithTraceInformation = Meta#{
                trace_id => TraceId, span_id => SpanId, dd => TraceInformation
            },
            LogEvent#{meta => MetaWithTraceInformation}
    end.
