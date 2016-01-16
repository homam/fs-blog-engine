# stateless modal component
# props:
# on-yes :: -> Void
# on-no ::  -> Void
# question :: String

{create-class, create-factory, DOM:{div, button, input, textarea, form}}:React = require 'react'

module.exports = create-class do
    display-name: 'Dialog'

    render: ->
        div class-name: 'dialog-overlay', on-click: (~> @props.on-no!),

            div class-name: 'dialog',
                div null, 
                    @props.question
                div class-name: 'controls',
                    button do
                        ref: 'no', type: 'button', class-name: 'no', on-click: (event) ~> 
                            @props.on-no!
                        'No'

                    button do 
                        ref: 'yes', type: 'button', class-name: 'yes', on-click: (event) ~> 
                            @props.on-yes!
                        'Yes'
