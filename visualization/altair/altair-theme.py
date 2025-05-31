# I want to create a custom Altair theme for my visualizations.
import altair as alt
from altair import theme

# Useful tip
#label_style = {
#    "condition": [{"test" : "datum.value == 'Jeremy Corbyn'", "value": "bold"}],
#    "value": "italic"
#}
# y=alt.Y("Page:N", axis=alt.Axis(title="", labelFontStyle=label_style))

# Updated Economist theme based on the provided recommendations
# To have ticks that crosses the axis you need to cdraw them manually with mark rule.
# 
# Custom tick marks as vertical rules
# Define custom tick positions
# ticks = pd.DataFrame({'x': df['x'], 'y': [0]*len(df)})
# tick_marks = alt.Chart(ticks).mark_rule(strokeWidth=1).encode(
#    x='x:Q',
#    y=alt.value(-5),    # extend a little above the axis
#    y2=alt.value(5),     # and below
#    color=alt.value('black')
#)
# To remove the gridline at 0 for the y-axis you also need to remove the grid lines from the y-axis and draw them manually with mark rule.
# y_ticks = [v for v in np.arange(df['y'].min(), df['y'].max()+1, step=10) if v != 0]
# y = alt.Y('y:Q', axis=alt.Axis(values=y_ticks))
# grid_values = [v for v in np.arange(df['y'].min(), df['y'].max()+1, 10) if v != 0]
#
# grid = alt.Chart(pd.DataFrame({'y': grid_values})).mark_rule(strokeDash=[2,2], color='lightgray').encode(
#    y='y:Q'
#)
# Remember
# y=alt.Y('y:Q', axis=alt.Axis(grid=False))
@theme.register("economist", enable=True)  # Register and enable the theme
def economist_theme() -> theme.ThemeConfig:
    return {
        'config': {
            'view': {
                'continuousWidth': 595,
                'stroke': 'transparent',  # Remove border around the chart
            },
            'title': {
                'fontSize': 17,  # Match "Econ sans bold 9.5/11pt"
                'fontWeight': 'bold',
                'color': '#000000',  # Black color for the title
                'anchor': 'start',
                #'color': '#333333',
                'subtitlePadding': 6,
                'subtitleFont': 'Econ sans cnd regular',
                'subtitleFontWeight': 'normal',
                'subtitleFontSize': 14,
                'subtitleColor': '#000000',  # Black color for the subtitle
                'offset': 26,
            },
            'axisX': {
                'titleFont': 'Econ sans cnd regular',
                'titleFontSize': 13,
                'titlePadding': 20,
                'labelFont': 'Econ sans cnd regular',
                'labelFontSize': 13,
                'labelPadding': 5,
                'grid': False,
                'tickSize': -3,
                'domainWidth': 0.7,
                'domainColor': '#000000',
                'tickColor': '#000000',
                'domainWidth': 0.7,
            },
            'axisY': {
                'labelFont': 'Econ sans cnd regular',
                'labelFontSize': 13,
                'title': None,
                'ticks': None,
                'domain': False,
                'labelBaseline': 'line-bottom',
                'labelAlign': 'right',
                'labelPadding': 0,
                'orient': 'right',
                'gridWidth': 0.5,
                'gridColor': '#ACBFBF', # Light
                # 'gridColor': 
            },
            'background': '#D9E9F0',  # Light blue background
        }
    }


# Test with a simpler scatter plot
def test_economist_theme():
    # Create a simple scatter plot
    data = alt.Data(values=[{'x': 1, 'y': 2}, {'x': 2, 'y': 3}, {'x': 3, 'y': 5}])
    chart = alt.Chart(data).mark_point().encode(
        x=alt.X('x:Q', title='axis label cnd regular', scale=alt.Scale(domain=[0,3.1])),
        y=alt.Y('y:Q')
    ).properties(
        title={
            'text': 'Simple Scatter Plot',
            'subtitle': 'Subtitle in cnd regular font',            
        }
    )  # Ensure the y-axis starts at zero

    return chart

def test_economist_theme_with_bar_chart():
    data = alt.Data(values=[
        {'category': 'A', 'value': 10},
        {'category': 'B', 'value': 15},
        {'category': 'C', 'value': 7}
    ])
    chart = alt.Chart(data).mark_bar().encode(
        x=alt.X('category:N', title='Category'),  # Categorical scale
        y=alt.Y('value:Q', title='Value')        # Quantitative scale
    ).properties(
        title='Bar Chart with Economist Theme'
    )

    return chart


# Run the test function to see the theme in action
if __name__ == "__main__":
    chart = test_economist_theme()
    #chart.show()  # This will display the chart in a Jupyter notebook or compatible environment
    chart.save('scatter_plot.html')