{create-class, create-factory, DOM:{div, button, input, textarea, form}}:React = require \react
{find-DOM-node} = require \react-dom

module.exports = create-class do
    display-name: 'New-Post'

    render: ->
        form ref: \newPost, 
            textarea placeholder: 'Title', value: @state.title, on-change: (event) ~> 
                @set-state title: event.target.value
            textarea placeholder: 'Header', value: @state.header, on-change: (event) ~> 
                @set-state header: event.target.value
            textarea placeholder: 'Body', value: @state.body, on-change: (event) ~> 
                @set-state body: event.target.value
            button value: 'Post!', type: 'button', on-click: ~>
                
                {header, body, title} = @state

                fetch '/api/new', {
                    method: 'post'
                    headers:
                        'Accept': 'application/json'
                        'Content-Type': 'application/json'
                    
                    body: JSON.stringify {
                        header: header
                        body: body
                        title: title
                    }
                }
                .then (-> ok = it.ok; it.json!.then (res) -> [ok, res]) .then ([ok, res]) ~> 
                    if ok
                        @props.on-new-post!
                    #TODO: handle the error
                .catch -> 
                    #TODO: handle the error
                    console.error it


    get-initial-state: -> 
        {
            title: null
            header: null
            body: null
        }