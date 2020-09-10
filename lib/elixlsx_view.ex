defmodule ElixlsxView do
  @moduledoc """
  This library is used to render data as xlsx documents in phoenix
  views.

  ## Instalation

  Add the library into your `deps/0`:

      defp deps do
        [
          {:elixlsx_view, "~> 0.1"}
        ]
      end

  ## Usage

  First you need to register mime type for xlsx and configure phoenix
  to use this library to manage rendering. Add this to your
  `confix.exs`:

      config :mime, :types, %{
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" =>
          ["xlsx"]
      }

      config :phoenix, :format_encoders,
        xlsx: ElixlsxView.Encoder

  After configuration is done, you can use it like you do with any
  other mime type (i.e. json or html), but the view function needs to
  return `%Elixlsx.Workbook{}` struct instead of a simple map like in
  json view.

  > **Note:** You probably don't need to do content negotiation and
  > instead of `plug accept, ["xlsx"]` put `plug put_format, "xlsx"`
  > in your pipeline.

  ## Example

  Here goes an example of application with xlsx endpint.

      defmodule MyApp.Report do
        @moduledoc false

        def generate do
          [
            %{name: "John", number: 1},
            %{name: "Phil", number: 2},
            %{name: "Zak", number: 3}
          ]
        end
      end

      defmodule MyAppWeb.Router do
        @moduledoc false

        use MyAppWeb, :router

        pipeline :xlsx do
          plug :put_format, "xlsx"
        end

        scope "/", MyAppWeb do
          pipe_through [:xlsx]
          get "/report", ReportController, :generate
        end
      end

      defmodule MyAppWeb.ReportController do
        @moduledoc false

        use MyAppWeb, :controller

        alias MyApp.Report

        def generate(conn, _params) do
          report = Report.generate()
          render(conn, :report, report: report)
        end
      end

      defmodule MyAppWeb.ReportView do
        @moduledoc false

        use MyAppWeb, :view

        alias Elixlsx.{Sheet, Workbook}
        alias ElixlsxView.Style

        @styles [
          title: [size: 14, bold: true],
          name: [italic: true],
          number: [bg_color: "#aaa"]
        ]

        def render("report.xlsx", %{report: report}) do
          %Workbook{sheets: [render_sheet(report)]}
        end

        defp render_sheet(report) do
          %Sheet{}
          |> Sheet.set_at(0, 0, "Name", classes: [:title])
          |> Sheet.set_at(0, 1, "Number", classes: [:title])
          |> put_rows(report)
          |> Style.apply(@styles)
        end

        defp put_rows(sheet, report) do
          {sheet, _} =
            Enum.reduce(report, {sheet, 1}, fn
              %{name: name, number: number}, {sheet, row} ->
                sheet =
                  sheet
                  |> Sheet.set_at(row, 0, name, classes: [:name])
                  |> Sheet.set_at(row, 1, number, classes: [:number])

                {sheet, row + 1}
            end)

          sheet
        end
      end
  """
end
