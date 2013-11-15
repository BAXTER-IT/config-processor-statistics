<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:s="http://baxter-it.com/config/statistics" xmlns:c="http://baxter-it.com/config/component" xmlns:conf="http://baxter-it.com/config"
    xmlns:log="http://baxter-it.com/config/log" xmlns:j="http://baxter-it.com/config/jvm" exclude-result-prefixes="xs s c conf log j"
    version="2.0">

    <xsl:import href="baxterxsl:repo-base.xsl" />
    <xsl:import href="baxterxsl:viewer.xsl" />
    <xsl:import href="baxterxsl:conf-reference.xsl" />

    <xsl:template name="product-title">
        <xsl:text>Statistics Server</xsl:text>
    </xsl:template>

    <xsl:template name="load-sources">
        <xsl:apply-templates select="conf:configuration-source/conf:request" mode="load-document-with-variants">
            <xsl:with-param name="prefix" select="'jvm'" />
        </xsl:apply-templates>
        <xsl:apply-templates select="conf:configuration-source/conf:request" mode="load-document-with-variants">
            <xsl:with-param name="prefix" select="'log'" />
        </xsl:apply-templates>
        <conf:samples>
            <conf:reference id="jvmConfigUnix" componentId="statistics-server" type="jvm">
                <conf:parameter name="osfamily">unix</conf:parameter>
            </conf:reference>
            <conf:reference id="jvmConfigWindows" componentId="statistics-server" type="jvm">
                <conf:parameter name="osfamily">windows</conf:parameter>
            </conf:reference>
            <conf:reference id="statistics" componentId="statistics-server" type="statistics" />
        </conf:samples>
    </xsl:template>

    <xsl:template match="conf:request">
        <xsl:apply-imports />
        <p>There is currently just one component provided with this product - Statistics Server component.</p>

        <h4>Java Virtual Machine Configuration</h4>
        <p>
            Typically you run stat server on linux, and the start script applies settings from:
            <br />
            <xsl:apply-templates select="/conf:samples/conf:reference[@id='jvmConfigUnix']" mode="anchor" />
        </p>
        <p>
            But if you are crazy enough and run statistics server on windows then your start script should pick up these
            settings:
            <br />
            <xsl:apply-templates select="/conf:samples/conf:reference[@id='jvmConfigWindows']" mode="anchor" />
        </p>

        <h4>Logging Configuration</h4>
        <p>
            Statistics Server uses
            <xsl:value-of select="/j:configuration/j:logging[c:component/@id='statistics-server']/conf:reference/@type" />
            framework for logging. Its configuration can be checked here:
            <br />
            <xsl:apply-templates select="/j:configuration/j:logging[c:component/@id='statistics-server']/conf:reference"
                mode="anchor">
                <xsl:with-param name="componentId" select="'statistics-server'" />
            </xsl:apply-templates>
        </p>

        <h4>Statistics Configuration</h4>
        <p>
            The Statistics Server uses following data for the rest of configuration:
            <br />
            <xsl:apply-templates select="/conf:samples/conf:reference[@id='statistics']" mode="anchor" />
        </p>

    </xsl:template>

</xsl:stylesheet>
