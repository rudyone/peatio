module ApplicationHelper
  def document_to(key: nil, title: nil, &block)
    if title
      link_to(title, '', :data => {:remote => "#{main_app.document_path(key)}", :toggle => "modal", :target => '#document_modal'})
    elsif block
      link_to('', :data => {:remote => "#{main_app.document_path(key)}", :toggle => "modal", :target => '#document_modal'}, &block)
    end
  end

  def detail_section_tag(title)
    content_tag('span', title, :class => 'detail-section') + \
    tag('hr')
  end

  def detail_tag(obj, title: 'detail', field: nil, cls: '', clip: nil)
    if field.present?
      field = field.to_s
      val = obj.instance_eval(field)
      display = val || 'N/A'
      content_tag('span', :class => "#{field} detail-item #{val ? nil : 'empty'}" + cls, :data => {:title => obj.class.han(field)}) do
        if clip and val
          content_tag('i', display, :class => 'fa fa-copy', :data => {:'clipboard-text' => display})
        else
          content_tag('span', display)
        end
      end
    else
      content_tag('span', obj, :class => 'detail-item ' + cls, :data => {title: title})
    end
  end

  def cs_link
    link_to t('helpers.action.customer_service'), "javascript:void(0);", :onclick => "olark('api.box.expand')"
  end

  def check_active(klass)
    return 'active' if (klass.model_name.singular == controller.controller_name.singularize)
  end

  def blockchain_url(txid)
    "https://blockchain.info/tx/#{txid}"
  end

  def qr_tag(data)
    data = QREncoder.encode(data).png.resize(220, 220).to_data_url
    image_tag(data, :class => 'qrcode img-rounded')
  end

  def rev_category(type)
    type.to_sym == :bid ? :ask : :bid
  end

  def currency_icon(type)
    t("currency.icon.#{type}")
  end

  def currency_format(type)
    t("currency.format.#{type}")
  end

  def orders_json(orders)
    Jbuilder.encode do |json|
      json.array! orders do |order|
        json.id order.id
        json.bid order.bid
        json.ask order.ask
        json.category order.kind
        json.volume order.volume
        json.price order.price
        json.origin_volume order.origin_volume
        json.at order.created_at.to_i
      end
    end
  end

  def link_to_block(payment_address)
    uri = case payment_address.currency
    when 'btc' then "https://blockchain.info/address/#{payment_address.address}"
    end
    link_to t("actions.block"), uri, target: '_blank'
  end

  def top_nav_link(link_text, link_path, link_icon)
    class_name = current_page?(link_path) ? 'active' : ''

    content_tag(:li, :class => class_name) do
      link_to link_path do
        content_tag(:i, :class => "fa fa-#{link_icon}") do end + 
        content_tag(:span, link_text)
      end
    end
  end

  def simple_vertical_form_for(record, options={}, &block)
    result = simple_form_for(record, options, &block)
    result = result.gsub(/#{SimpleForm.form_class}/, "simple_form").html_safe
    result.gsub(/col-sm-\d/, "").html_safe
  end
end
