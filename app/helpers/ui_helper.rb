module UiHelper

  def card(user)
    link_to user_path(user) do
      content_tag(:div, class: 'card is-fullwidth') do
        content_tag(:div, class: 'card-content') do
          output = []

          media = content_tag(:div, class: 'media') do
            output2 = []

            media_left = content_tag(:div, class: 'media-left') do
              content_tag(:figure, class: 'image is-48x48') do
                image_tag avatar_url(user)
              end
            end

            media_content = content_tag(:div, class: 'media-content horizontal-center') do
              output3 = []

              title = content_tag(:p, user.full_name, class: 'title is-5')
              subtitle = content_tag(:p, user.first_year, class: 'subtitle is-6')

              output3 << title
              output3 << subtitle

              output3.join("\n").html_safe
            end

            output2 << media_left
            output2 << media_content

            output2.join("\n").html_safe
          end

          content = content_tag(:div, class: 'content') do
            content_tag(:small) do
              "Ultima actualizacion: #{time_ago_in_words user.updated_at}"
            end
          end

          output << media
          output << content

          output.join("\n").html_safe
        end
      end
    end
  end

  def company_logo(profesional_contact)
    host = URI.parse(profesional_contact.company_website).host
    image_tag "http://logo.clearbit.com/#{host}?size=64", onerror: 'this.style.display = "none"'
  end

end
