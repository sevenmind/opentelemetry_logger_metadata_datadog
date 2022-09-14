# OpentelemetryLoggerMetadataDataDog

Adds OpenTelemetry trace identifiers to logs in the datadog format. i.e. adds `{"dd": {"trace_id":12315400,"span_id":8944345}}` to your logger metadata.

Logging into a json format with [logger_json](https://github.com/Nebo15/logger_json) is recommended. 

## Installation

### Elixir

The package can be installed by adding `opentelemetry_logger_metadata_datadog` to your
list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:opentelemetry_logger_metadata_datadog, "~> 0.1.0"}
  ]
end
```

In your application start:

```elixir
    def start(_type, _args) do
      OpentelemetryLoggerMetadataDataDog.setup()

      # ...
    end
```

### Erlang

The package can be installed by adding `opentelemetry_logger_metadata_datadog` to your
list of dependencies:

```
  {deps, [{opentelemetry_logger_metadata_datadog, "~> 0.1.0"}]}.
```

In your application start:

```erlang
  opentelemetry_logger_metadata_datadog:setup()
```

or setup the logging filter yourself:

```erlang
  logger:add_primary_filter(opentelemetry_logger_metadata_datadog, {fun opentelemetry_logger_metadata_datadog:filter/2, []}),
```
