{**
 * Список топиков
 *}

{extends './layout.base.tpl'}



{block 'layout_content'}
    {component 'topic.list' topics=$topics paging=$paging}
{/block}