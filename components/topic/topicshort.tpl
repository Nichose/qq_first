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


<div class="news-item ">
    <div class="flex flex-wrap">
        
        {$previewImage = $topic->getPreviewImageWebPath(Config::Get('module.topic.default_preview_size'))}
        
        <div class="news-item-image">
            <img src="{$previewImage}" />
        </div>
        
        <div class="news-item-info flex flex-column">
            
                    {* Блоги *}
        {$_blogs = []}

        {if ! $isPreview}
            {foreach $topic->getBlogs() as $blog}
                {if $blog->getType() != 'personal'}
                    {$_blogs[] = [ title => $blog->getTitle()|escape, url => $blog->getUrlFull() ]}
                {/if}
            {/foreach}
        {/if}

        {if $_blogs}
            <ul class="{$component}-blogs">
                {foreach $_blogs as $blog}
                    <a href="{$blog.url}">{$blog.title}</a>{if ! $blog@last}, {/if}
                {/foreach}
            </ul>
        {/if}
            
            <h2><a href="{$topic->getUrl()}">{$topic->getTitle()|escape}</a></h2>
        </div>
        
        
        
    </div>

    <div>
        {component 'user' template='avatar' user=$user size='text' mods='inline'}
        
        <time datetime="{date_format date=$topic->getDatePublish() format='c'}" title="{date_format date=$topic->getDatePublish() format='j F Y, H:i'}">
                                {date_format date=$topic->getDatePublish() format="j F Y, H:i"}
                            </time>
        
        {if $isList && ( ! $topic->getForbidComment() || ( $topic->getForbidComment() && $topic->getCountComment() ) )}
            {$topic->getCountComment()}
        
            {if $_countCommentNew}
                +{$_countCommentNew}
            {/if}
        {/if}
    </div>   
</div>
