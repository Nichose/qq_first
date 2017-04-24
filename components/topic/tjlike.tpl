{**
 * Базовый шаблон топика
 * Используется также для отображения превью топика
 *
 * @param object  $topic
 * @param boolean $isList
 * @param boolean $isPreview
 *}

{$component = 'short-topic'}
{component_define_params params=[ 'type', 'topic', 'isPreview', 'isList', 'mods', 'classes', 'attributes' ]}

{$user = $topic->getUser()}
{$type = ($topic->getType()) ? $topic->getType() : $type}

{if ! $isList}
    {$mods = "{$mods} single"}
{/if}

{$classes = "{$classes} topic js-topic"}

{block 'topic_options'}{/block}



<div class="{$component} {cmods name=$component mods=$mods} {$classes}" {cattr list=$attributes}>
    {**
     * Хидер
     *}
    <div class="{$component}-header">
        
        <span class="{$component}-info-item {$component}-info-item--date">
            <time datetime="{date_format date=$topic->getDatePublish() format='c'}" title="{date_format date=$topic->getDatePublish() format='j F Y, H:i'}">
                {date_format date=$topic->getDatePublish() format="j F Y, H:i"}
            </time>
        </span>
        
        <div class="{$component}-info-item {$component}-info-item--author">
            {component 'user' template='avatar' user=$user size='text' mods='inline'}
        </div>
        
    </div>
    
    <div class="{$component}-content">
        <span class="{$component}-title ls-word-wrap">
            {if $topic->getPublish() == 0}
                    {component 'syn-icon' icon='draft' attributes=[ title => {lang 'topic.is_draft'} ]}
            {/if}
            
            <a href="{$topic->getUrl()}">{$topic->getTitle()|escape}</a>
        </span>
        
        {* Превью *}
        {$previewImage = $topic->getPreviewImageWebPath(Config::Get('module.topic.default_preview_size'))}
        
        {if $previewImage}
            <div class="ls-topic-preview-image">
                <img src="{$previewImage}" />
            </div>
        {/if}
        
        <span class="{$component}-text ls-text">
                    {if $isList and $topic->getTextShort()}
                        {$topic->getTextShort()}
                    {else}
                        {$topic->getText()}
                    {/if}
        </span>
    </div>
    
    <div class="{$component}-footer">
    
        {* Голосование *}
                        {if ! $isPreview}
                            <span class="{$component}-info-item {$component}-info-item--vote">
                                {$isExpired = strtotime($topic->getDatePublish()) < $smarty.now - Config::Get('acl.vote.topic.limit_time')}

                                {component 'vote'
                                         target     = $topic
                                         classes    = 'js-vote-topic'
                                         useAbstain = true
                                         isLocked   = ( $oUserCurrent && $topic->getUserId() == $oUserCurrent->getId() ) || $isExpired
                                         showRating = $topic->getVote() || ($oUserCurrent && $topic->getUserId() == $oUserCurrent->getId()) || $isExpired}
                            </span>
                        {/if}
                                
                                
        {* Ссылка на комментарии *}
                        {* Не показываем если комментирование запрещено и кол-во комментариев равно нулю *}
                        {$_countCommentNew = $topic->getCountCommentNew()}

                        {if $isList && ( ! $topic->getForbidComment() || ( $topic->getForbidComment() && $topic->getCountComment() ) )}
                            <span class="{$component}-info-item {$component}-info-item--comments {if $_countCommentNew}{$component}-info-item--comments--has-new{/if}">
                                <a href="{$topic->getUrl()}#comments">
                                    <span class="{$component}-info-item--comments-count">{$topic->getCountComment()}</span>

                                    {if $_countCommentNew}
                                        <span class="{$component}-info-item--comments-new">+{$_countCommentNew}</span>
                                    {/if}
                                </a>
                            </span>
                        {/if}
        
    </div>
    </div>
    