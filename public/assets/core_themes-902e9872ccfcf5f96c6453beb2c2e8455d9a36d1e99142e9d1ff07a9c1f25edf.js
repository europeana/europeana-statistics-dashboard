function dataFinding(t){"One Dimensional Charts"==genre&&(t.color_mode="shade");var e=0;config_data=t,final_config={};var a=$(".cstm-form-control:input"),i=[];colorRepetation=[],countgroup=1;for(var o in current_config)config_data[o]=current_config[o];for(o=0;o<a.length;o++)if("core_theme_name"!=a[o].id)if(i.push(a[o].type),"number"===a[o].type.toLowerCase())a[o].value=config_data[$(a)[o].id],final_config[$(a)[o].id]=config_data[$(a)[o].id];else if("textbox"===a[o].type.toLowerCase())$(a)[o].value=config_data[$(a)[o].id]||"",final_config[$(a)[o].id]=config_data[$(a)[o].id];else if("text"===a[o].type.toLowerCase())$(a)[o].value=config_data[$(a)[o].id]||"",final_config[$(a)[o].id]=config_data[$(a)[o].id];else if("color"===a[o].type.toLowerCase())$(a)[o].value=config_data[$(a)[o].id]||"",final_config[$(a)[o].id]=config_data[$(a)[o].id];else if("color1"===$(a[o]).attr("reference")){1===e&&(e=0),e+=.2;var r=config_data[a[o].id];"chart_color"===a[o].id&&(r=r[0]);var c=hex2rgb(r),n=("rgba("+c[0]+","+c[1]+","+c[2]+","+e+")",RGBAtoRGB(c[0],c[1],c[2],e,255,255,255)),l=rgbToHex(n);a[o].value=l,$($(a[o])[0].parentElement).attr("data-color",l),$($(a[o])[0].previousElementSibling.childNodes[1]).css("background-color",l),"chart_color"===a[o].id&&countgroup<=5&&(5===countgroup?colorRepetation+=l:colorRepetation+=l+";",countgroup++)}else"checkbox"===a[o].type.toLowerCase()?($(a)[o].value=config_data[$(a)[o].id],"yes"===config_data[$(a)[o].id]?$(a)[o].checked=!0:$(a)[o].checked=!1,final_config[$(a)[o].id]=config_data[$(a)[o].id]):"select-one"===a[o].type.toLowerCase()&&($(a)[o].value=config_data[$(a)[o].id],final_config[$(a)[o].id]=config_data[$(a)[o].id]);config_data.data=parsed_data,config_data.selector=selector,init()}function init(){obj&&(config_data.title_text=""!=obj.title_text.toString().trim()?obj.title_text:config_data.title_text,config_data.subtitle_text=""!=obj.subtitle_text.toString().trim()?obj.subtitle_text:config_data.subtitle_text),obj=config_data,$(selector).empty(),config_data.map_code=map_code,final_config.map_code=map_code,obj.title_text&&"[entertitlehere]"==obj.title_text.trim().replace(/ /g,"").toLowerCase()&&$("#title_text").val(""),obj.subtitle_text&&"[entersubtitlehere]"==obj.subtitle_text.trim().replace(/ /g,"").toLowerCase()&&$("#subtitle_text").val("");var t="";t=colorRepetation,"Pictograph"!=chart_name&&"Grid"!==chart_name&&(config_data.chart_color=colorRepetation.split(";").reverse(),$("[id1='array_text']").attr("value",t.split(";").reverse().join(";"))),colorRepetation=[],t="",countgroup=1,initializeTheChart("true")}function hex2rgb(t){return["0x"+t[1]+t[2]|0,"0x"+t[3]+t[4]|0,"0x"+t[5]+t[6]|0]}function RGBAtoRGB(t,e,a,i,o,r,c){var n=Math.round((1-i)*o+i*t),l=Math.round((1-i)*r+i*e),s=Math.round((1-i)*c+i*a);return"rgb("+n+","+l+","+s+")"}function rgbToHex(t){if("#"===t.substr(0,1))return t;var e=/(.*?)rgb\((\d+),\s*(\d+),\s*(\d+)\)/i.exec(t),a=parseInt(e[2],10).toString(16),i=parseInt(e[3],10).toString(16),o=parseInt(e[4],10).toString(16);return"#"+((1==a.length?"0"+a:a)+(1==i.length?"0"+i:i)+(1==o.length?"0"+o:o))}function expandAndCollapseAllPanels(){$(".panel-body").hasClass("in")?$(".panel-body").removeClass("in"):($(".panel-body").addClass("in").css("height","auto"),$(".in").prev().removeClass("collapsed"))}Rumali.ConfigThemeSubmitForm=function(){$("#theme_submit").click(function(){var t=JSON.stringify(obj);$("#core_theme_config").val(t)})};var chart,current_config={},chart_html_tag,parsed_data,org_data;Rumali.liveEditor=function(){var t,e,a=function(t){data.data=parsed_data,"Grid"!==chart_name&&dataFinding(data),$(".theme_configuration").click(function(){$(".execute1").attr("checked",!1);var t=JSON.parse($(this).attr("config"));dataFinding(t)}),$("#expandCollapse").click(function(t){t.preventDefault(),expandAndCollapseAllPanels()}),$(":input.execute1").on("click",function(){if("radio"==this.type){if("chart_color"!=this.id){var t=this.id;final_config[t]!==$(this).val()&&final_config[t]!==parseFloat($(this).val())&&(current_config[t]=$(this).val()),obj[this.id]=this.value,final_config[this.id]=this.value}initializeTheChart("true")}}),$(":input.execute2").on("click",function(){var t=this.id,e=[];if("chart_color_boolean0"===t)colorRepetation=$("[id1='array_text']").val(),$("[id1='array_text']").attr("value",colorRepetation),obj.chart_color=colorRepetation.split(";"),final_config.chart_color=obj.chart_color,$(".identity1").attr("disabled",!0),$(".identity2").attr("disabled",!1);else{var a=$(".execute3:checked");if(a.length)for(var i=0;i<a.length;i++)e.push(a[i].value);else e.push(obj.chart_color[0]);obj.chart_color=e,final_config.chart_color=e,$(".identity1").attr("disabled",!1),$(".identity2").attr("disabled",!0)}initializeTheChart("true")}),$(".execute3").on("click",function(){if("checked"===$("#chart_color_boolean1").attr("checked")){for(var t=this.id,e=[],a=$(".execute3:checked"),i=0;i<a.length;i++)e.push(a[i].value);obj[t]=e,final_config[t]=e,initializeTheChart("true")}}),$(":input.execute").on("blur",function(){var t=this.id;if(obj[t]=$("#"+this.id).val(),final_config[t]!==$(this).val()&&final_config[t]!==parseFloat($(this).val())&&"chart_color"!=t&&(current_config[t]=$(this).val()),final_config[t]=$("#"+this.id).val(),"chart_color"===t){if("checked"===$("#chart_color_boolean0").attr("checked")){obj[t]=this.value.split(";"),final_config[t]=obj[t]}}else"select-one"==this.type?"fixed"==$("#"+this.id).val()?$("."+$(this).attr("disableinputs1")).each(function(){$(this).attr("disabled",!1)}):"moving"==$("#"+this.id).val()?$("."+$(this).attr("disableinputs1")).each(function(){$(this).attr("disabled",!0)}):"color"==$("#"+this.id).val()?$("."+$(this).attr("disableinputs1")).each(function(){$(this).attr("disabled",!0)}):$("."+$(this).attr("disableinputs1")).each(function(){$(this).attr("disabled",!1)}):"checkbox"==this.type&&(this.checked?($("."+$(this).attr("disableinputs")).each(function(){$(this).attr("disabled",!1)}),obj[t]="yes",final_config[t]="yes",current_config[this.id]="yes"):($("."+$(this).attr("disableinputs")).each(function(){$(this).attr("disabled",!0)}),obj[t]="no",current_config[this.id]="no",final_config[t]="no"));""===obj[t]||isNaN(obj[t])||(obj[t]=parseInt(obj[t]),final_config[t]=parseInt(obj[t])),("axis_x_pointer_values"===t||"axis_y_pointer_values"===t||"clubdata_always_include_data_points"===t)&&(obj[t]=obj[t].toString().split(";"),final_config[t]=obj[t]),PykCharts.interval&&clearInterval(PykCharts.interval),"palette_color"==t&&(obj.saturation_color="",final_config.saturation_color=""),initializeTheChart("true")}),$("#color_mode").change(function(){"color"==this.value?($("#color_group").show(),$("#saturation_group").hide()):($("#color_group").hide(),$("#saturation_group").show())}),$("#zoom_enable").click(function(){this.checked?$("#zoom_level").attr("disabled",!1):$("#zoom_level").attr("disabled",!0)}),$(".color").colorpicker().on("hide",function(t,e){if($(this).children()[1].checked)if($(this).has(".execute3").length>0){if("checked"===$(selector).attr("checked")){for(var a=$(this).find(".execute3")[0].id,i=[],o=$(".execute3:checked"),r=0;r<o.length;r++){var c=$($(o[r])[0].previousElementSibling.childNodes[1]).css("background-color");i.push(c)}obj[a]=i,final_config[a]=i,initializeTheChart("true")}}else if($(this).has(".execute1").length>0&&"radio"==$(this).find(".execute1")[0].type){$(selector).empty();var a=$(this).find(".execute1")[0].id;if("chart_color"!=a){var c=$(this).find(".circle").css("background-color");obj[a]=c,final_config[this.id]=c}initializeTheChart("true")}}),$("#core_viz_update").click(function(){var t=obj;("[entertitlehere]"==t.title_text.trim().replace(/ /g,"").toLowerCase()||""==t.title_text.trim().replace(/ /g,"").toLowerCase())&&(t.title_text=""),("[entersubtitlehere]"==t.subtitle_text.trim().replace(/ /g,"").toLowerCase()||""==t.subtitle_text.replace(/ /g,"").toLowerCase())&&(t.subtitle_text=""),t.data="",$("#core_viz_config").val(JSON.stringify(t))})},i=function(t){org_data=t,o(),a(org_data)},o=function(){var t;"true"===chart_html_tag.dataset.filter_present?($("#filter_container").show(),unique_filter_html=renderFilter(org_data,chart_html_tag.dataset.filter_column_name,"filter_show"),$("#filter_container").html(unique_filter_html),$("#filter_show").change(function(){t=$("#filter_show option:selected").val(),parsed_data=filterChart(org_data,chart_html_tag.dataset.filter_column_name,t),a(parsed_data)}),$("select#filter_show").prop("selectedIndex",0),t=$("#filter_show option:selected").val(),parsed_data=filterChart(org_data,chart_html_tag.dataset.filter_column_name,t)):($("#filter_container").hide(),parsed_data=org_data)};chart_html_tag=$("#chart_container")[0],t=chart_html_tag.dataset.datacast_identifier,e=Rumali.object.datacast_url+t,getJSON(e,i)};var initializeTheChart=function(t){"Grid"!==chart_name&&($("#title").remove(),$("#subtitle").remove(),"true"==t&&(""==obj.title_text&&(obj.title_text="[ Enter Title Here ]"),""==obj.subtitle_text&&(obj.subtitle_text="[ Enter Subtitle Here ]")),chart&&chart.interval&&clearInterval(chart.interval),chart=new initializer(obj),d3.selectAll(".pyk-tooltip").remove(),$(selector).empty(),chart.execute(),"true"==t&&giveTitleProperties())},giveTitleProperties=function(){$("#title").ready(function(){$("#title").attr("contenteditable","true"),$("#title").blur(function(){var t=this.innerText.trim();$(this).attr("contenteditable","true"),$("#title_text").val(t),obj.title_text=t,""==t&&initializeTheChart("true")}),$("#title").keydown(function(t){13===t.keyCode&&$(this).attr("contenteditable","false")})}),$("#sub-title").ready(function(){$("#sub-title").attr("contenteditable","true"),$("#sub-title").blur(function(){var t=this.innerText.trim();$(this).attr("contenteditable","true"),$("#subtitle_text").val(t),obj.subtitle_text=t,""==t&&initializeTheChart("true")}),$("#sub-title").keydown(function(t){13===t.keyCode&&$(this).attr("contenteditable","false")})})},getApiFromString=function(t){return t=t.split("."),PykCharts[t[1]][t[2]]};window.onload=function(){switch(gon.scopejs){case"scopejs_themes_new":case"scopejs_themes_create":case"scopejs_themes_edit":case"scopejs_themes_update":Rumali.ConfigThemeSubmitForm(),Rumali.liveEditor();break;case"scopejs_vizs_new":case"scopejs_vizs_create":Rumali.chartView();break;case"scopejs_vizs_edit":case"scopejs_vizs_update":"Grid"!==chart_name&&"One Number indicators"!==chart_name?Rumali.liveEditor():"One Number indicators"!==chart_name?Rumali.showAndEditGridPage():Rumali.showAndEditBoxPage();break;case"scopejs_datacast_pulls_create":case"scopejs_datacasts_file":case"scopejs_datacasts_upload":Rumali.newDataStorePage();break;case"scopejs_vizs_show":"Grid"!==chart_name?Rumali.showChartPage():Rumali.showAndEditGridPage();break;case"scopejs_datacasts_new":case"scopejs_datacasts_create":Rumali.dataCastNewPage();break;case"scopejs_datacasts_edit":case"scopejs_datacasts_update":Rumali.dataCastNewPage(),Rumali.initDataCastGrid();break;case"scopejs_articles_edit":case"scopejs_articles_update":Rumali.newArticleCreate();case"scopejs_reports_show":Rumali.buildCharts.loadReportChart();case"scopejs_reports_new":case"scopejs_reports_create":case"scopejs_reports_edit":case"scopejs_reports_update":Rumali.reportsNewPage()}};