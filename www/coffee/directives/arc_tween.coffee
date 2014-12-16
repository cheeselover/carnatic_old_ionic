angular.module('carnatic.directives')

.directive 'arcTween', ->
  return {
    restrict: 'E'
    scope: { val: '=' }
    link: (scope, element, attrs) ->
      width = 500
      height = 360
      tau = 2 * Math.PI # http://tauday.com/tau-manifesto

      # An arc function with all values bound except the endAngle. So, to compute an
      # SVG path string for a given angle, we pass an object with an endAngle
      # property to the `arc` function, and it will return the corresponding string.
      arc = d3.svg.arc()
          .innerRadius(60)
          .outerRadius(80)
          .startAngle(0)

      # Create the SVG container, and apply a transform such that the origin is the
      # center of the canvas. This way, we don't need to position arcs individually.
      svg = d3.select(element[0]).append("svg")
          .attr("width", width)
          .attr("height", height)
        .append("g")
          .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")")

      # Add the background arc, from 0 to 100% (tau).
      background = svg.append("path")
          .datum({ endAngle: tau })
          .style("fill", "#ddd")
          .attr("d", arc)

      # Add the foreground arc in orange, currently showing 12.7%.
      foreground = svg.append("path")
          .datum({ endAngle: .75 * tau })
          .style("fill", "orange")
          .attr("d", arc)

      # Every so often, start a transition to a new random angle. Use transition.call
      # (identical to selection.call) so that we can encapsulate the logic for
      # tweening the arc in a separate function below.

      # setInterval(->
      #   foreground.transition()
      #       .duration(750)
      #       .call(arcTween, Math.random() * tau)
      # , 1500)

      scope.$watch 'val', (newVal, oldVal) ->
        if not newVal or newVal is oldVal
          return
        else
          foreground.transition().duration(750).call(arcTween, newVal / 100 * tau)

      # Creates a tween on the specified transition's "d" attribute, transitioning
      # any selected arcs from their current angle to the specified new angle.
      arcTween = (transition, newAngle) ->
        # The function passed to attrTween is invoked for each selected element when
        # the transition starts, and for each element returns the interpolator to use
        # over the course of transition. This function is thus responsible for
        # determining the starting angle of the transition (which is pulled from the
        # element's bound datum, d.endAngle), and the ending angle (simply the
        # newAngle argument to the enclosing function).
        transition.attrTween "d", (d) ->
          # To interpolate between the two angles, we use the default d3.interpolate.
          # (Internally, this maps to d3.interpolateNumber, since both of the
          # arguments to d3.interpolate are numbers.) The returned function takes a
          # single argument t and returns a number between the starting angle and the
          # ending angle. When t = 0, it returns d.endAngle; when t = 1, it returns
          # newAngle; and for 0 < t < 1 it returns an angle in-between.
          interpolate = d3.interpolate(d.endAngle, newAngle)

          # The return value of the attrTween is also a function: the function that
          # we want to run for each tick of the transition. Because we used
          # attrTween("d"), the return value of this last function will be set to the
          # "d" attribute at every tick. (It's also possible to use transition.tween
          # to run arbitrary code for every tick, say if you want to set multiple
          # attributes from a single function.) The argument t ranges from 0, at the
          # start of the transition, to 1, at the end.
          return (t) ->
            # Calculate the current arc angle based on the transition time, t. Since
            # the t for the transition and the t for the interpolate both range from
            # 0 to 1, we can pass t directly to the interpolator.
            #
            # Note that the interpolated angle is written into the element's bound
            # data object! This is important: it means that if the transition were
            # interrupted, the data bound to the element would still be consistent
            # with its appearance. Whenever we start a new arc transition, the
            # correct starting angle can be inferred from the data.
            d.endAngle = interpolate(t)

            # Lastly, compute the arc path given the updated data! In effect, this
            # transition uses data-space interpolation: the data is interpolated
            # (that is, the end angle) rather than the path string itself.
            # Interpolating the angles in polar coordinates, rather than the raw path
            # string, produces valid intermediate arcs during the transition.
            return arc(d)
  }
