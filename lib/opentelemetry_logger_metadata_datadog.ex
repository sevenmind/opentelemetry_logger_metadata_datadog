defmodule OpentelemetryLoggerMetadataDataDog do
  @moduledoc """
  Adds OpenTelemetry trace identifiers to logs.

  In your application start:

  ```elixir
      def start(_type, _args) do
        OpentelemetryLoggerMetadataDataDog.setup()

        # ...
      end
  ```
  """

  def setup do
    :opentelemetry_logger_metadata_datadog.setup()
  end
end
