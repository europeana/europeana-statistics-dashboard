module StaticPages
  class Index < Europeana::Styleguide::View
    def page_title
      'Europeana Statistics Dashboard'
    end

    def bodyclass
      "europeana_statsdashboard page_home"
    end

    def navigation
      { global: {} }
    end

    def css_files
      [
        { path: styleguide_url('/css/statistics/screen.css'), media: 'all', title: nil }
      ]
    end

    def js_files
      [
        {
        	path: asset_path('application.js')
        },
        {
          path: styleguide_url('/js/dist/require.js'),
          data_main: styleguide_url('/js/dist/main/main-statistics.js'),
        }
      ]
    end
    def title
    	""
    end

    def content
    	{
    	 	"charts": {
    			"main_chart": {
		        "id": "europeana_navigator_map"
		      }
		    }
		  }
    end

    def gon
    	helpers.include_gon
    end
  end
end
