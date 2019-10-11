class Orden
    include ActiveModel::Serializers::JSON

    attr_accessor :orden, :secuencia, :valor,
                  :nombres, :direccion, :ciudad ,:departamento ,
                  :telefono, :trasportadora, :barcode, :items

    def attributes=(hash)
        hash.each do |key, value|
            send("#{key}=", value)
        end
    end

    def attributes
        instance_values
    end



    def print
        report = Thinreports::Report.new layout: 'orderF.tlf'


        # 1st page
        report.list do |list|



            report.list.header do |header|
                header.item(:orden).value(orden)
                header.item(:secuencia).value(secuencia)
                header.item(:valor).value(valor)
                header.item(:nombres).value(nombres)
                header.item(:direccion).value(direccion)
                header.item(:ciudad).value(ciudad)
                header.item(:telefono).value(telefono)
                header.item(:transportadora).value(trasportadora)
                header.item(:codigobarras).src(barcode(:gs1_128, '1233'))

            end

            items.each do |item|
                list.add_row do |row|
                    row[:ean] = item[0]
                    row[:descripcion] = item[1]
                    row[:nombrezona] = item[2]
                    row[:cantidadstock] = item[3]
                    row[:cantidadpedido] = item[4]
                end
            end

            #list.on_page_footer_insert do |footer|
            #	footer.values SubTotal: SubTotal
            #	footer.values TotalDescuento: TotalDescuento
            #	footer.item(:TotalImpuesto).value(TotalImpuesto)
            #	footer.item(:TotalItem).value(items.length)
            #	footer.item(:Total).value(Total)
            #end

            #list.on_footer_insert do |footer|""
            #	footer.item(:metodos).value(metodos)
            #	footer.item(:montos).value(montos)
            #	footer.item(:Vendedor).value(Vendedor)
            #	footer.item(:Cajero).value(Cajero)
            #end
        end
        report.generate(filename:  "orden#{orden}.pdf")

    end


    require 'barby/barcode/gs1_128'
    require 'barby/barcode/qr_code'
    require 'barby/outputter/png_outputter'

    def barcode(type, data, png_opts = {})
        code = case type
               when :gs1_128
                   Barby::Code128.new(data)
               when :qr_code
                   Barby::QrCode.new(data)
               end
        StringIO.new(code.to_png(png_opts))
    end




end