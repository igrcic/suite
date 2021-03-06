<StyledLayerDescriptor version="1.0.0" xmlns="http://www.opengis.net/sld" xmlns:ogc="http://www.opengis.net/ogc" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.opengis.net/sld http://schemas.opengis.net/sld/1.0.0/StyledLayerDescriptor.xsd">
  <NamedLayer>
    <Name>cookbook:sld_cookbook_point</Name>
    <UserStyle>
      <Title>SLD Cook Book: Zoom-based Point</Title>
      <FeatureTypeStyle>
         <Rule>
           <Name>Large</Name>
           <MaxScaleDenominator>160000000</MaxScaleDenominator>
           <PointSymbolizer>
             <Graphic>
               <Mark>
                 <WellKnownName>circle</WellKnownName>
                 <Fill>
                   <CssParameter name="fill">#CC3300</CssParameter>
                 </Fill>
               </Mark>
               <Size>12</Size>
             </Graphic>
           </PointSymbolizer>
         </Rule>
         <Rule>
           <Name>Medium</Name>
           <MinScaleDenominator>160000000</MinScaleDenominator>
           <MaxScaleDenominator>320000000</MaxScaleDenominator>
           <PointSymbolizer>
             <Graphic>
               <Mark>
                 <WellKnownName>circle</WellKnownName>
                 <Fill>
                   <CssParameter name="fill">#CC3300</CssParameter>
                 </Fill>
               </Mark>
               <Size>8</Size>
             </Graphic>
           </PointSymbolizer>
         </Rule>
         <Rule>
           <Name>Small</Name>
           <MinScaleDenominator>320000000</MinScaleDenominator>
           <PointSymbolizer>
             <Graphic>
               <Mark>
                 <WellKnownName>circle</WellKnownName>
                 <Fill>
                   <CssParameter name="fill">#CC3300</CssParameter>
                 </Fill>
               </Mark>
               <Size>4</Size>
             </Graphic>
           </PointSymbolizer>
         </Rule>
       </FeatureTypeStyle>
    </UserStyle>
  </NamedLayer>
</StyledLayerDescriptor>
