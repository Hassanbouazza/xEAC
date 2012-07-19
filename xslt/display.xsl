<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:eac="urn:isbn:1-931666-33-4" xmlns="http://www.w3.org/1999/xhtml" xmlns:exsl="http://exslt.org/common"
	xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xi="http://www.w3.org/2001/XInclude">
	<xsl:include href="templates.xsl"/>
	<xsl:output method="xhtml" encoding="utf-8"/>

	<xsl:variable name="exist-url" select="//exist-url"/>
	<xsl:variable name="config" select="document(concat($exist-url, 'xeac/config.xml'))"/>
	<xsl:variable name="ui-theme" select="exsl:node-set($config)/config/theme/jquery_ui_theme"/>
	<xsl:param name="mode">
		<xsl:choose>
			<xsl:when test="contains(doc('input:request')/request/request-url, 'admin/')">private</xsl:when>
			<xsl:otherwise>public</xsl:otherwise>
		</xsl:choose>
	</xsl:param>
	<xsl:variable name="display_path">
		<xsl:choose>
			<xsl:when test="$mode='private'">
				<xsl:text>../../</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>../</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:template match="/">
		<xsl:apply-templates select="/content/eac:eac-cpf"/>
	</xsl:template>

	<xsl:template match="eac:eac-cpf">
		<html xml:lang="en" lang="en">
			<head>
				<title>
					<xsl:value-of select="exsl:node-set($config)/config/title"/>
					<xsl:text>: </xsl:text>
					<xsl:value-of select="eac:cpfDescription/eac:identity/eac:nameEntry[1]/eac:part"/>
				</title>
				<link rel="shortcut icon" href="{$display_path}images/favicon.png" type="image/png"/>
				<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.8.2r1/build/grids/grids-min.css"/>
				<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.8.2r1/build/reset-fonts-grids/reset-fonts-grids.css"/>
				<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.8.2r1/build/base/base-min.css"/>
				<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.8.2r1/build/fonts/fonts-min.css"/>
				<!-- Core + Skin CSS -->
				<link rel="stylesheet" type="text/css" href="http://yui.yahooapis.com/2.8.2r1/build/menu/assets/skins/sam/menu.css"/>

				<!-- EADitor styling -->
				<link rel="stylesheet" href="{$display_path}css/style.css"/>
				<link rel="stylesheet" href="{$display_path}css/themes/{$ui-theme}.css"/>

				<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js" type="text/javascript"/>
				<script type="text/javascript" src="{$display_path}javascript/jquery-ui-1.8.12.custom.min.js"/>
				<script type="text/javascript" src="{$display_path}javascript/menu.js"/>

				<!-- mapping -->
				<script src="http://www.openlayers.org/api/OpenLayers.js" type="text/javascript"/>
				<!--<script src="http://maps.google.com/maps/api/js?sensor=false"/>-->
				<!--<script src="http://maps.google.com/maps?file=api&amp;v=2&amp;key=ABQIAAAASI0kCI-azC8RgbOZzWc3VRRarOQe_TKf_51Omf6UUSOFm7EABRRhO0PO4nBAO9FCmVDuowVwROLo3w"
      type="text/javascript"></script>-->
				<script type="text/javascript" src="{$display_path}javascript/mxn.js"/>
				<script src="http://static.simile.mit.edu/timeline/api-2.2.0/timeline-api.js?bundle=true" type="text/javascript"/>
				<script type="text/javascript" src="{$display_path}javascript/timemap_full.pack.js"/>
				<script type="text/javascript" src="{$display_path}javascript/param.js"/>
				<script type="text/javascript" src="{$display_path}javascript/loaders/xml.js"/>
				<script type="text/javascript" src="{$display_path}javascript/loaders/kml.js"/>
				<script type="text/javascript" src="{$display_path}javascript/display_functions.js"/>
				<script type="text/javascript">
					$(document).ready(function(){
						initialize_timemap('<xsl:value-of select="//eac:recordId"/>');
					});
				</script>
			</head>
			<body class="yui-skin-sam">
				<div id="doc4" class="yui-t5">
					<!-- header -->
					<xsl:call-template name="header-public"/>
					<div id="bd">
						<xsl:call-template name="icons"/>
						<h1>
							<xsl:value-of select="eac:cpfDescription/eac:identity/eac:nameEntry[1]/eac:part"/>
						</h1>
						<xsl:call-template name="body"/>
						<!--<div id="yui-main">
							<div class="yui-b">
								<xsl:call-template name="body"/>
							</div>
						</div>
						<div class="yui-b">
							<xsl:call-template name="sidebar"/>
						</div>-->

					</div>


					<!-- footer -->
					<xsl:call-template name="footer-public"/>
				</div>
				<xsl:copy-of select="exsl:node-set($config)/config/google_analytics/*"/>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="body">
		<div id="timemap">
			<div id="mapcontainer">
				<div id="map"/>
			</div>
			<div id="timelinecontainer">
				<div id="timeline"/>
			</div>
		</div>

		<xsl:apply-templates select="eac:cpfDescription"/>
	</xsl:template>

	<xsl:template match="eac:cpfDescription">
		<div id="chron">
			<h2>Chronology</h2>
			<ul>
				<xsl:apply-templates select="eac:description/descendant::eac:date[@standardDate]|eac:description/descendant::eac:dateRange[eac:fromDate[@standardDate]]">
					<xsl:sort
						select="if(local-name()='date') then if (substring(@standardDate, 1, 1) = '-') then (number(tokenize(@standardDate, '-')[2]) * -1) else tokenize(@standardDate, '-')[1] else  if (substring(eac:fromDate/@standardDate, 1, 1) = '-') then (number(tokenize(eac:fromDate/@standardDate, '-')[2]) * -1) else tokenize(eac:fromDate/@standardDate, '-')[1]"/>
					<xsl:sort
						select="if(local-name()='date') then if (substring(@standardDate, 1, 1) = '-') then number(tokenize(@standardDate, '-')[3]) else tokenize(@standardDate, '-')[2] else  if (substring(eac:fromDate/@standardDate, 1, 1) = '-') then number(tokenize(eac:fromDate/@standardDate, '-')[3]) else tokenize(eac:fromDate/@standardDate, '-')[2]"/>
					<xsl:sort
						select="if(local-name()='date') then if (substring(@standardDate, 1, 1) = '-') then number(tokenize(@standardDate, '-')[4]) else tokenize(@standardDate, '-')[3] else  if (substring(eac:fromDate/@standardDate, 1, 1) = '-') then number(tokenize(eac:fromDate/@standardDate, '-')[4]) else tokenize(eac:fromDate/@standardDate, '-')[3]"
					/>
				</xsl:apply-templates>
			</ul>
		</div>

		<xsl:apply-templates select="eac:relations"/>
	</xsl:template>

	<xsl:template match="eac:date|eac:dateRange">
		<xsl:if test="not(parent::eac:existDates)">
			<li>
				<b><xsl:choose>
						<xsl:when test="local-name()='date'">
							<xsl:value-of select="."/>
						</xsl:when>
						<xsl:when test="local-name()='dateRange'">
							<xsl:value-of select="eac:fromDate"/>
							<xsl:text> - </xsl:text>
							<xsl:value-of select="eac:toDate"/>
						</xsl:when>
					</xsl:choose>: </b>
				<xsl:call-template name="chron-description"/>
			</li>
		</xsl:if>

	</xsl:template>

	<xsl:template name="chron-description">
		<xsl:choose>
			<xsl:when test="parent::eac:existDates">Dates of Existence</xsl:when>
			<xsl:when test="ancestor::eac:useDates">
				<xsl:text>Known as </xsl:text>
				<xsl:value-of select="ancestor::eac:nameEntry/eac:part"/>
			</xsl:when>
			<xsl:when test="parent::node()/eac:event">
				<xsl:value-of select="parent::node()/eac:event"/>
			</xsl:when>
			<xsl:when test="parent::node()/eac:term">
				<a href="{$display_path}results/?q={if (string(@localType)) then @localType else local-name()}_facet:&#x022;{parent::node()/eac:term}&#x022;">
					<xsl:value-of select="parent::node()/eac:term"/>
				</a>
			</xsl:when>
			<xsl:when test="parent::node()/eac:placeRole">
				<xsl:value-of select="parent::node()/eac:placeRole"/>
			</xsl:when>
			<xsl:when test="parent::node()/eac:placeEntry">
				<a href="{$display_path}results/?q={if (string(@localType)) then @localType else local-name()}_facet:&#x022;{parent::node()/eac:placeEntry}&#x022;">
					<xsl:value-of select="parent::node()/eac:placeEntry"/>
				</a>
			</xsl:when>
		</xsl:choose>
		<xsl:if test="string(parent::node()/eac:placeEntry) and not(parent::eac:place)">
			<xsl:text>, </xsl:text>
			<xsl:value-of select="parent::node()/eac:placeEntry"/>
			<xsl:text>.</xsl:text>
		</xsl:if>
	</xsl:template>


	<xsl:template match="eac:relations">
		<div id="relations">
			<h2>Relations</h2>
			<xsl:if test="count(eac:cpfRelation) &gt; 0">
				<h3>Related Corporate, Personal, and Family Names</h3>
				<ul>
					<xsl:apply-templates select="eac:cpfRelation"/>
				</ul>
			</xsl:if>
			<xsl:if test="count(eac:resourceRelation) &gt; 0">
				<h3>Related Resources</h3>
				<ul>
					<xsl:apply-templates select="eac:resourceRelation"/>
				</ul>
			</xsl:if>
		</div>
	</xsl:template>

	<xsl:template match="eac:cpfRelation|eac:resourceRelation">
		<li>
			<xsl:choose>
				<xsl:when test="string(@xlink:href)">
					<a href="{@xlink:href}">
						<xsl:if test="local-name()='resourceRelation'">
							<xsl:attribute name="target">_blank</xsl:attribute>
						</xsl:if>
						<xsl:value-of select="eac:relationEntry"/>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="eac:relationEntry"/>
				</xsl:otherwise>
			</xsl:choose>
		</li>
	</xsl:template>

	<xsl:template name="icons">
		<div class="submenu">
			<div class="icon">
				<a href="{$display_path}xml/{//eac:eac-cpf/eac:control/eac:recordId}">
					<img src="{$display_path}images/xml.png" title="XML" alt="XML"/>
				</a>
			</div>
			<div class="icon">
				<!-- AddThis Button BEGIN -->
				<div class="addthis_toolbox addthis_default_style ">
					<a class="addthis_button_preferred_1"/>
					<a class="addthis_button_preferred_2"/>
					<a class="addthis_button_preferred_3"/>
					<a class="addthis_button_preferred_4"/>
					<a class="addthis_button_compact"/>
					<a class="addthis_counter addthis_bubble_style"/>
				</div>
				<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#pubid=xa-4dd29d0e2f66557f"/>
				<!-- AddThis Button END -->
			</div>
		</div>
	</xsl:template>

	<!--<xsl:template name="regularize-name">
		<xsl:param name="name"/>
		<xsl:choose>
			<xsl:when test="$name = 'daogrp'">
				<xsl:text>Image</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'repository'">
				<xsl:text>Repository</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'origination'">
				<xsl:text>Creator</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'extent'">
				<xsl:text>Extent</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'dimensions'">
				<xsl:text>Dimensions</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'genreform'">
				<xsl:text>Genre/Format</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'physfacet'">
				<xsl:text>Physical Facet</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'physloc'">
				<xsl:text>Location</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'unitid'">
				<xsl:text>Identification</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'langmaterial'">
				<xsl:text>Language</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'abstract'">
				<xsl:text>Abstract</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'materialspec'">
				<xsl:text>Technical</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'container'">
				<xsl:text>Container</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'bioghist'">
				<xsl:text>Biographical/Historical Commentary</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'scopecontent'">
				<xsl:text>Scope and Content</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'controlaccess'">
				<xsl:text>Controlled Access Headings</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'arrangement'">
				<xsl:text>Arrangement</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'accessrestrict'">
				<xsl:text>Access Restriction</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'userestrict'">
				<xsl:text>Use Restriction</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'prefercite'">
				<xsl:text>Preferred Citation</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'acqinfo'">
				<xsl:text>Acquisition Information</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'altformavail'">
				<xsl:text>Alternate Form Available</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'accruals'">
				<xsl:text>Accruals</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'appraisal'">
				<xsl:text>Appraisal</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'custodhist'">
				<xsl:text>Custodial History</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'processinfo'">
				<xsl:text>Processing Information</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'originalsloc'">
				<xsl:text>Location of Originals</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'phystech'">
				<xsl:text>Physical Characteristics</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'odd'">
				<xsl:text>Other Descriptive Data</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'note'">
				<xsl:text>Note</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'descgrp'">
				<xsl:text>Descriptive Group</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'bibliography'">
				<xsl:text>Bibliography</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'relatedmaterial'">
				<xsl:text>Related Material</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'separatedmaterial'">
				<xsl:text>Separated Material</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'otherfindaid'">
				<xsl:text>Other Finding Aid</xsl:text>
			</xsl:when>
			<xsl:when test="$name = 'fileplan'">
				<xsl:text>Fileplan</xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>Other Name</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>-->
</xsl:stylesheet>
