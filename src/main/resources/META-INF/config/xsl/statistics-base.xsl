<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:s="http://baxter-it.com/config/statistics"
	xmlns:c="http://baxter-it.com/config/component" xmlns:conf="http://baxter-it.com/config"
	xmlns="http://baxter-it.com/statistics/config"
	exclude-result-prefixes="xs s c conf" version="2.0">

	<xsl:import href="baxterxsl:repo-base.xsl" />
	<xsl:import href="baxterxsl:text-fmt.xsl" />
	<xsl:import href="baxterxsl:conf-reference.xsl" />

	<xsl:output encoding="UTF-8" method="xml" indent="yes"
		omit-xml-declaration="no" />

	<xsl:param name="configurationComponentId" />

	<xsl:template match="/">
		<xsl:variable name="root">
			<xsl:copy-of select="conf:configuration-source/conf:request" />
			<xsl:apply-templates select="conf:configuration-source/conf:request"
				mode="load-document-with-variants">
				<xsl:with-param name="prefix" select="'/com/baxter/statistics/stats'" />
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:apply-templates select="$root/s:configuration" />
	</xsl:template>

	<xsl:template
		match="s:configuration[$configurationComponentId='statistics-server']">
		<statistics>
			<server>
				<xsl:attribute name="port" select="s:udp/@port" />
			</server>
			<xsl:apply-templates select="s:disruptor" />
			<exposers>
				<xsl:for-each select="s:jmx-sql-exposer">
					<jmx-sql-exposer>
						<xsl:copy-of select="@*" />
						<query>
							<xsl:apply-templates />
						</query>
					</jmx-sql-exposer>
				</xsl:for-each>
				<xsl:for-each select="s:jmx-exposer">
					<jmx-exposer>
						<xsl:copy-of select="@*" />
					</jmx-exposer>
				</xsl:for-each>
			</exposers>
		</statistics>
	</xsl:template>

	<xsl:template match="s:configuration">
		<statistics>
			<server>
				<xsl:attribute name="host" select="s:udp/@host" />
				<xsl:attribute name="port" select="s:udp/@port" />
			</server>
			<xsl:for-each select="s:disabled-lmp">
				<disabled-lmp>
					<xsl:apply-templates />
				</disabled-lmp>
			</xsl:for-each>
		</statistics>
	</xsl:template>

	<xsl:template match="s:disruptor">
		<disruptor>
			<xsl:copy-of select="@*" />
			<xsl:apply-templates />
		</disruptor>
	</xsl:template>

	<xsl:template match="s:persistence-handler">
		<persistence-handler>
			<xsl:copy-of select="@*" />
			<xsl:apply-templates />
		</persistence-handler>
	</xsl:template>

	<xsl:template match="s:connection">
		<connection>
			<xsl:copy-of select="@*" />
		</connection>
	</xsl:template>

</xsl:stylesheet>
