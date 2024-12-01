module Admin::ReportsHelper
    def bar_chart_options(chart_id)
      {
        chart: { type: 'bar' },
        xaxis: { title: { text: 'Tagi' } },
        yaxis: { title: { text: 'Liczba petycji' } },
        dataLabels: { enabled: true },
        div: { id: chart_id }
      }
    end
  
    def pie_chart_options(labels, chart_id)
      {
        chart: { type: 'pie' },
        labels: labels,
        dataLabels: { enabled: true },
        div: { id: chart_id }
      }
    end
  
    def line_chart_options(chart_id)
      {
        chart: { type: 'line' },
        xaxis: { title: { text: 'Miesiąc' } },
        yaxis: { title: { text: 'Liczba petycji' } },
        dataLabels: { enabled: true },
        div: { id: chart_id }
      }
    end
  end
  