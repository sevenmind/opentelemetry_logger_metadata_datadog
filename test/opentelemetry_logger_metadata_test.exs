defmodule OpentelemetryLoggerMetadataDataDogTest do
  use ExUnit.Case
  doctest OpentelemetryLoggerMetadataDataDog

  import ExUnit.CaptureLog

  require Logger
  require OpenTelemetry.Tracer

  setup do
    Logger.configure_backend(
      :console,
      format: {LogstashLoggerFormatter, :format},
      colors: [enabled: false],
      metadata: :all
    )

    OpentelemetryLoggerMetadataDataDog.setup()

    :ok
  end

  test "does not add trace identifiers when not in a trace" do
    message = capture_log(fn -> Logger.warn("Test message") end)
    decoded_message = Jason.decode!(message)
    refute Map.has_key?(decoded_message, "trace_id")
    refute Map.has_key?(decoded_message, "span_id")
  end

  test "adds trace_id and span_id to log metadata when in a trace" do
    OpenTelemetry.Tracer.with_span "test span" do
      message = capture_log(fn -> Logger.warn("Test message") end)
      decoded_message = Jason.decode!(message)

      assert Map.has_key?(decoded_message, "trace_id")
      assert Map.has_key?(decoded_message, "span_id")
      assert Map.has_key?(decoded_message, "dd")
    end
  end

  describe "trace_id_to_dd/1" do
    test "converts otel trace_id to datadog trace_id" do
      otel_trace_id_dd = "3442339c95bbc90e2b30ad60c6a372eb"
      dd_trace_id = "3112177973674078955"

      assert :opentelemetry_logger_metadata_datadog.trace_id_to_dd(otel_trace_id_dd) ==
               dd_trace_id
    end
  end
end
