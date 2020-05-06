{**
 * templates/frontend/objects/article_details.tpl
 *
 * Copyright (c) 2014-2018 Simon Fraser University
 * Copyright (c) 2003-2018 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief View of an Article which displays all details about the article.
 *  Expected to be primary object on the page.
 *
 * Many journals will want to add custom data to this object, either through
 * plugins which attach to hooks on the page or by editing the template
 * themselves. In order to facilitate this, a flexible layout markup pattern has
 * been implemented. If followed, plugins and other content can provide markup
 * in a way that will render consistently with other items on the page. This
 * pattern is used in the .main_entry column and the .entry_details column. It
 * consists of the following:
 *
 * <!-- Wrapper class which provides proper spacing between components -->
 * <div class="item">
 *     <!-- Title/value combination -->
 *     <div class="label">Abstract</div>
 *     <div class="value">Value</div>
 * </div>
 *
 * All styling should be applied by class name, so that titles may use heading
 * elements (eg, <h3>) or any element required.
 *
 * <!-- Example: component with multiple title/value combinations -->
 * <div class="item">
 *     <div class="sub_item">
 *         <div class="label">DOI</div>
 *         <div class="value">12345678</div>
 *     </div>
 *     <div class="sub_item">
 *         <div class="label">Published Date</div>
 *         <div class="value">2015-01-01</div>
 *     </div>
 * </div>
 *
 * <!-- Example: component with no title -->
 * <div class="item">
 *     <div class="value">Whatever you'd like</div>
 * </div>
 *
 * Core components are produced manually below, but can also be added via
 * plugins using the hooks provided:
 *
 * Templates::Article::Main
 * Templates::Article::Details
 *
 * @uses $article Article This article
 * @uses $issue Issue The issue this article is assigned to
 * @uses $section Section The journal section this article is assigned to
 * @uses $primaryGalleys array List of article galleys that are not supplementary or dependent
 * @uses $supplementaryGalleys array List of article galleys that are supplementary
 * @uses $keywords array List of keywords assigned to this article
 * @uses $pubIdPlugins Array of pubId plugins which this article may be assigned
 * @uses $copyright string Copyright notice. Only assigned if statement should
 *   be included with published articles.
 * @uses $copyrightHolder string Name of copyright holder
 * @uses $copyrightYear string Year of copyright
 * @uses $licenseUrl string URL to license. Only assigned if license should be
 *   included with published articles.
 * @uses $ccLicenseBadge string An image and text with details about the license
 *}

<article class="obj_article_details">

	<h1 class="page_title">
		{$article->getLocalizedTitle()|escape}
	</h1>

	{if $article->getLocalizedSubtitle()}
		<h2 class="subtitle">
			{$article->getLocalizedSubtitle()|escape}
		</h2>
	{/if}

	{* assign Author biographies *}
			{assign var="hasBiographies" value=0}
			{foreach from=$article->getAuthors() item=author}
				{if $author->getLocalizedBiography()}
					{assign var="hasBiographies" value=$hasBiographies+1}
				{/if}
			{/foreach}

	<div class="row">
		<div class="main_entry">

		{* pruebas *}
		
    
			{* DOI (requires plugin) *}
			{foreach from=$pubIdPlugins item=pubIdPlugin}
				{if $pubIdPlugin->getPubIdType() != 'doi'}
					{continue}
				{/if}
				{assign var=pubId value=$article->getStoredPubId($pubIdPlugin->getPubIdType())}
				{if $pubId}
					{assign var="doiUrl" value=$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
					<div class="item doi content_doi">
						<label>
							{capture assign=translatedDOI}{translate key="plugins.pubIds.doi.readerDisplayName"}{/capture}
							{translate key="semicolon" label=$translatedDOI}
						<label>
						<span class="value">
							<a href="{$doiUrl}">
								{$doiUrl}
							</a>
				
						</span>
					</div>
				{/if}
			{/foreach}
  

		{* BARRA DE NAVEGACION*}

						<ul id="myTabs" class="nav nav-tabs nav_info_article" role="tablist">
							{if $article->getLocalizedAbstract()}
								
									<li role="presentation" class="active"><a href="#abstract" id="abstract-tab" role="tab" data-toggle="tab" aria-controls="abstract" aria-expanded="true">
										<span class="glyphicon glyphicon-book" aria-hidden="true"></span> 
										<strong>{translate key="article.abstract"}</strong>
									</a></li>
								
							{/if}
							{if !empty($keywords[$currentLocale])}
							
									<li role="presentation" >
										<a href="#subject"  role="tab" id="subject-tab" data-toggle="tab" aria-controls="subject">
											<span class="glyphicon glyphicon-tags" aria-hidden="true"></span> 
											<strong>{*capture assign=translatedKeywords*}{translate key="article.subject"}{*/capture*}
											{*translate key="semicolon" label=$translatedKeywords*}</strong>
										</a>
									</li>
							
							{/if}
							{if $hasBiographies}
									<li role="presentation" >
										<a href="#authorBiographies"  role="tab" id="authorBiographies-tab" data-toggle="tab" aria-controls="authorBiographies">
										<span class="glyphicon glyphicon-edit" aria-hidden="true"></span>
										<strong> 
										{if $hasBiographies > 1}
											{translate key="submission.authorBiographies"}
										{else}
											{translate key="submission.authorBiography"}
										{/if}
										</strong>
										</a>
									</li>
							{/if}
							{if $parsedCitations || $publication->getData('citationsRaw')}
								
									<li role="presentation" >
										<a href="#citations"  role="tab" id="citations-tab" data-toggle="tab" aria-controls="citations">
										<span class="glyphicon glyphicon-info-sign" aria-hidden="true"></span> 
										<strong>{translate key="submission.citations"}</strong>
										</a>
									</li>
							{/if}
						</ul>
					


	<div id="myTabContent" class="tab-content">

			{* Abstract *}
			{if $article->getLocalizedAbstract()}
				<div id="abstract" role="tabpanel" class="amx-div-tabs tab-pane fade in active" aria-labelledby="abstract-tab">
				<h3 class="label label_h3">{translate key="article.abstract"}</h3>
					{$article->getLocalizedAbstract()|strip_unsafe_html}
			{*Authors*}
			
				<h3 class="label label_h3">{translate key="article.authors"}</h3>		
			
				{if $article->getAuthors()}
				
					<ul class="item authors">
					{foreach from=$article->getAuthors() item=author}
						<li>
							<span class="name">
								{$author->getFullName()|escape}
							</span>
							{if $author->getLocalizedAffiliation()}
								<span class="affiliation">
									{$author->getLocalizedAffiliation()|escape}
								</span>
							{/if}
							{if $author->getOrcid()}
								<span class="orcid">
									{$orcidIcon}
									<a href="{$author->getOrcid()|escape}" target="_blank">
										{$author->getOrcid()|escape}
									</a>
								</span>
							{/if}
						</li>
					{/foreach}
				</ul>
			{/if}
			
			{*Include usageStats*}
								{call_hook name="Templates::Article::Main"}
				</div>
			{/if}

			{* Keywords *}
			{if !empty($keywords[$currentLocale])}
			<div id="subject"  role="tabpanel" class="amx-div-tabs tab-pane fade" aria-labelledby="subject-tab">
				<h3 class="label label_h3">
					{*capture assign=translatedKeywords*}{translate key="article.subject"}{*/capture*}
					{*translate key="semicolon" label=$translatedKeywords*}
				</h3>
				<ul id="keywords_list" class="content_keywords">
					{foreach from=$keywords item=keyword}
						{foreach name=keywords from=$keyword item=keywordItem}
							<li>{$keywordItem|escape}</li>{*if !$smarty.foreach.keywords.last}, {/if*}
						{/foreach}
					{/foreach}
				</ul>
			</div>
			{/if}

		{* Authors 	
			{if $article->getAuthors()}
				
				<ul class="item authors">
					{foreach from=$article->getAuthors() item=author}
						<li>
							<span class="name">
								{$author->getFullName()|escape}
							</span>
							{if $author->getLocalizedAffiliation()}
								<span class="affiliation">
									{$author->getLocalizedAffiliation()|escape}
								</span>
							{/if}
							{if $author->getOrcid()}
								<span class="orcid">
									{$orcidIcon}
									<a href="{$author->getOrcid()|escape}" target="_blank">
										{$author->getOrcid()|escape}
									</a>
								</span>
							{/if}
						</li>
					{/foreach}
				</ul>
			{/if}
		*}


			{* Author biographies / la asignacion de la variable esta al inicio de la pag*}
			
			{if $hasBiographies}
				<div id="authorBiographies" role="tabpanel" class="amx-div-tabs tab-pane fade" aria-labelledby="authorBiographies-tab">
					<h3 class="label label_h3">
						{if $hasBiographies > 1}
							{translate key="submission.authorBiographies"}
						{else}
							{translate key="submission.authorBiography"}
						{/if}
					</h3>
					{foreach from=$article->getAuthors() item=author}
						{if $author->getLocalizedBiography()}
							<div class="sub_item">
								<br>
									{if $author->getLocalizedAffiliation()}
										{capture assign="authorName"}<label>{$author->getFullName()|escape}</label>{/capture}										
										{capture assign="authorAffiliation"}<span class="affiliation">{$author->getLocalizedAffiliation()|escape}</span>{/capture}
										{translate key="submission.authorWithAffiliation" name=$authorName affiliation=$authorAffiliation}
									{else}
										<label>{$author->getFullName()|escape}</label>
									{/if}
								
								<div class="value">
									{$author->getLocalizedBiography()|strip_unsafe_html}
								</div>
							</div>
						{/if}
					{/foreach}
				</div>
			{/if}

			{* References *}
			{if $parsedCitations || $publication->getData('citationsRaw')}
				<div id="citations" role="tabpanel" class="amx-div-tabs tab-pane fade" aria-labelledby="citations-tab">
					<h3 class="label label_h3">
						{translate key="submission.citations"}
					</h3>
					<div class="value">
						{if $parsedCitations}
							{iterate from=parsedCitations item=parsedCitation}
								<p>{$parsedCitation->getCitationWithLinks()|strip_unsafe_html} {call_hook name="Templates::Article::Details::Reference" citation=$parsedCitation}</p>
							{/iterate}
						{elseif $article->getCitations()}
							{$article->getCitations()|nl2br}
						{/if}
					</div>
				</div>
			{/if}
		</div>
		</div><!-- .main_entry -->
	

		<div class="entry_details">

			{* Article/Issue cover image *}
			{if $article->getLocalizedCoverImage() || $issue->getLocalizedCoverImage()}
				<div class="item cover_image">
					<div class="sub_item">
						{if $article->getLocalizedCoverImage()}
							<img src="{$article->getLocalizedCoverImageUrl()|escape}"{if $article->getLocalizedCoverImageAltText()} alt="{$article->getLocalizedCoverImageAltText()|escape}"{/if}>
						{else}
							<a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
								<img src="{$issue->getLocalizedCoverImageUrl()|escape}"{if $issue->getLocalizedCoverImageAltText()} alt="{$issue->getLocalizedCoverImageAltText()|escape}"{/if}>
							</a>
						{/if}
					</div>
				</div>
			{/if}

			

			{* Article Galleys *}
				<div class="item galleys">
					<ul class="value galleys_links">
				{foreach from=$article->getGalleys() item=galley}
							<li>
								{include file="frontend/objects/galley_link.tpl" parent=$article galley=$galley}
							</li>
						{/foreach}
					</ul>
				</div>
			{if $supplementaryGalleys}
				<div class="item galleys">
					<ul class="value supplementary_galleys_links">
						{foreach from=$supplementaryGalleys item=galley}
							<li>
								{include file="frontend/objects/galley_link.tpl" parent=$article galley=$galley isSupplementary="1"}
							</li>
						{/foreach}
					</ul>
				</div>
			{/if}

			{if $article->getDatePublished()}
				<div class="item published">
					<div class="label">
						{translate key="submissions.published"}
					</div>
					<div class="value">
						{$article->getDatePublished()|date_format:$dateFormatShort}
					</div>					
				</div>
			{/if}

			{* COUNTER *}
					<div class="item">
								<font color='#DA251D'><span class="glyphicon glyphicon-stats" aria-hidden="true"></span> | </font>
								<span class="glyphicon glyphicon-eye-open" aria-hidden="true"></span> {$article->getViews()} |
								{if $galleys}
									{foreach from=$galleys item=galley name=galleyList}
										<span class="glyphicon glyphicon-download" aria-hidden="true"></span> {$galley->getGalleyLabel()} - {$galley->getViews()} | 
									{/foreach}
								{/if}
					</div>
					

			{* How to cite *}
			{if $citation}
				<div class="item citation">
					<div class="sub_item citation_display">
						<div class="label">
							{translate key="submission.howToCite"}
						</div>
						<div class="value">
							<div id="citationOutput" role="region" aria-live="polite">
								{$citation}
							</div>
							<div class="citation_formats">
								<button class="cmp_button citation_formats_button" aria-controls="cslCitationFormats" aria-expanded="false" data-csl-dropdown="true">
									{translate key="submission.howToCite.citationFormats"}
								</button>
								<div id="cslCitationFormats" class="citation_formats_list" aria-hidden="true">
									<ul class="citation_formats_styles">
										{foreach from=$citationStyles item="citationStyle"}
											<li>
												<a
													aria-controls="citationOutput"
													href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgs}"
													data-load-citation
													data-json-href="{url page="citationstylelanguage" op="get" path=$citationStyle.id params=$citationArgsJson}"
												>
													{$citationStyle.title|escape}
												</a>
											</li>
										{/foreach}
									</ul>
									{if count($citationDownloads)}
										<div class="label">
											{translate key="submission.howToCite.downloadCitation"}
										</div>
										<ul class="citation_formats_styles">
											{foreach from=$citationDownloads item="citationDownload"}
												<li>
													<a href="{url page="citationstylelanguage" op="download" path=$citationDownload.id params=$citationArgs}">
														<span class="fa fa-download"></span>
														{$citationDownload.title|escape}
													</a>
												</li>
											{/foreach}
										</ul>
									{/if}
								</div>
							</div>
						</div>
					</div>
				</div>
			{/if}

			{* Issue article appears in *}
			<div class="item issue">
				<div class="sub_item">
					<div class="label">
						{translate key="issue.issue"}
					</div>
					<div class="value">
						<a class="title" href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
							{$issue->getIssueIdentification()}
						</a>
					</div>
				</div>

				{if $section}
					<div class="sub_item">
						<div class="label">
							{translate key="section.section"}
						</div>
						<div class="value">
							{$section->getLocalizedTitle()|escape}
						</div>
					</div>
				{/if}
			</div>

			{* PubIds (requires plugins) *}
			{foreach from=$pubIdPlugins item=pubIdPlugin}
				{if $pubIdPlugin->getPubIdType() == 'doi'}
					{continue}
				{/if}
				{assign var=pubId value=$article->getStoredPubId($pubIdPlugin->getPubIdType())}
				{if $pubId}
					<div class="item pubid">
						<div class="label">
							{$pubIdPlugin->getPubIdDisplayType()|escape}
						</div>
						<div class="value">
							{if $pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
								<a id="pub-id::{$pubIdPlugin->getPubIdType()|escape}" href="{$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}">
									{$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
								</a>
							{else}
								{$pubId|escape}
							{/if}
						</div>
					</div>
				{/if}
			{/foreach}

			{foreach from=$pubIdPlugins item=pubIdPlugin}
				{if $pubIdPlugin->getPubIdType() != 'doi'}
					{continue}
				{/if}
				{assign var=pubId value=$article->getStoredPubId($pubIdPlugin->getPubIdType())}
				{if $pubId}
					<span class="__dimensions_badge_embed__" data-doi="{$pubId|escape}"></span><script async src="https://badge.dimensions.ai/badge.js" charset="utf-8"></script>
				{/if}
			{/foreach}

			{* Licensing info *}
			{if $copyright || $licenseUrl}
				<div class="item copyright">
					{if $licenseUrl}
						{if $ccLicenseBadge}
							{if $copyrightHolder}
								<p>{translate key="submission.copyrightStatement" copyrightHolder=$copyrightHolder copyrightYear=$copyrightYear}</p>
							{/if}
							{$ccLicenseBadge}
						{else}
							<a href="{$licenseUrl|escape}" class="copyright">
								{if $copyrightHolder}
									{translate key="submission.copyrightStatement" copyrightHolder=$copyrightHolder copyrightYear=$copyrightYear}
								{else}
									{translate key="submission.license"}
								{/if}
							</a>
						{/if}
					{/if}
					{$copyright}
				</div>
			{/if}

			{call_hook name="Templates::Article::Details"}

		</div><!-- .entry_details -->
	</div><!-- .row -->

</article>

