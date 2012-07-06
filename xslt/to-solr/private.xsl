<?xml version="1.0" encoding="UTF-8"?>
<?cocoon-disable-caching?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:datetime="http://exslt.org/dates-and-times" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:eac="urn:isbn:1-931666-33-4" version="2.0">
	<xsl:output method="xml" encoding="UTF-8"/>

	<xsl:template match="/">
		<add>
			<xsl:apply-templates select="eac:eac-cpf"/>
		</add>
	</xsl:template>

	<xsl:template match="eac:eac-cpf">
		<doc>
			<field name="id">
				<xsl:value-of select="eac:control/eac:recordId"/>
			</field>
			<xsl:for-each select="eac:cpfDescription/eac:identity/eac:nameEntry">
				<xsl:if test="position() = 1">
					<field name="name">
						<xsl:value-of select="eac:part"/>
					</field>
				</xsl:if>
				<field name="name_text">
					<xsl:value-of select="eac:part"/>
				</field>
			</xsl:for-each>
		</doc>
	</xsl:template>


</xsl:stylesheet>
