(function() {
  "use strict"
  const margin = {top: 20, right: 30, bottom: 40, left: 40},
        width = 960 - margin.left - margin.right,
        height = 500 - margin.top - margin.bottom

  const yAttr = (d) => d['real']

  var x = d3.scale.ordinal()
      .rangeRoundBands([0, width])
  var xOffset = d3.scale.ordinal()
  var y = d3.scale.linear()
      .range([height, 0])
  var loadcolor = d3.scale.category10()

  var xAxis = d3.svg.axis()
      .scale(x)
      .orient('bottom')

  var yAxis = d3.svg.axis()
      .scale(y)
      .orient('left')

  var chart = d3.select('#chart')
      .attr('width', width + margin.left + margin.right)
      .attr('height', height + margin.top + margin.bottom)
    .append('g')
      .attr('transform', `translate(${margin.left}, ${margin.right})`);

  chart.append('g')
      .attr('class', 'x axis')
      .attr('transform', `translate(0, ${height})`)
  chart.append('g')
      .attr('class', 'y axis')

  var legend = d3.select('#legend')
      .attr('width', 100)
  legend.append('g')
      .attr('transform', 'translate(10, 10)')

  drawCSV('i30pc74/benchmark1-00.csv')

  function drawCSV(url) {
    d3.csv(url, function(err, data) {
      if (err) alert(err)
      else draw(data)
    })
  }

  var prevDomain = []
  function draw(data) {
    x.domain(data.map((d) => d.benchmark))
    prevDomain = [d3.min(data.map(yAttr).concat(prevDomain)), d3.max(data.map(yAttr).concat(prevDomain))]
    y.domain(prevDomain).nice();
    xOffset
      .domain(data.map((d) => d.loadconfig))
      .rangeRoundBands([0, x.rangeBand()], 1)
    loadcolor.domain(data.map((d) => d.loadconfig))
    drawLegend()

    chart.select('.x.axis').call(xAxis)
    chart.select('.y.axis').call(yAxis)

    var points = chart.selectAll('circle')
        .data(data)
    points.transition()
        .call(updatePoints)
    points.enter().append('circle')
        .attr('r', 5)
        .call(updatePoints)
    points.exit().remove()

    function updatePoints(sel) {
      sel
        .attr('cx', (d, i) => x(d.benchmark))
        .attr('cy', (d, i) => y(yAttr(d)))
        .attr('transform', (d) => `translate(${xOffset(d.loadconfig)}, 0)`)
        .attr('fill', (d) => loadcolor(d.loadconfig))
    }
  }

  function drawLegend() {
    legend
        .attr('height', 15 * loadcolor.domain().length + 5)
    var rows = legend.select('g').selectAll('g')
        .data(loadcolor.domain())
    var g = rows.enter().append('g')
    g.append('circle')
        .attr('r', 5)
        .attr('cx', 2.5)
        .attr('cy', (d, i) => i * 15)
    g.append('text')
        .attr('x', 20)
        .attr('y', (d, i) => i * 15 + 2.5)
    rows.selectAll('circle')
        .attr('fill', (d) => loadcolor(d))
    rows.selectAll('text')
        .text((d) => d)
  }

  var benchmarks = {
    i30pc74: ['00', '01', '02'],
  }
  var benchmarksel = d3.select('#benchmarksel')
  var rows = benchmarksel.selectAll('tr')
      .data(Object.keys(benchmarks))
  rows.enter().append('tr')
      .append('td')
        .text((t) => t)
  rows.selectAll('td:not(:first-child)')
      .data((pc) => benchmarks[pc].map((b) => ({pc: pc, benchmark: b})))
    .enter().append('td').append('button')
      .text((t) => t.benchmark)
      .on('click', (t) => drawCSV(`${t.pc}/benchmark1-${t.benchmark}.csv`))

})();
