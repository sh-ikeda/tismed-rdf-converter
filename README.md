# TiSMeD RDF converter
組織特異的遺伝子発現のデータベース [TiSMeD](https://www.bio-add.org/TiSMeD/index.jsp) の RDF 化を行うスクリプト群。

## 入力ファイル
- TSGs.tsv
  - 配布元: https://www.bio-add.org/TiSMeD/download.jsp
  - csv を tsv に変換したもの
- TSPs.tsv
  - 同上
- tismed_tissue_hierarchy.tsv
  - [元論文](https://www.cell.com/molecular-therapy-family/nucleic-acids/fulltext/S2162-2531(26)00055-7) の Table S5。
  - 末尾に要らない半角スペースが入っていることがあるので取り除いておく。
```tsv
System Term	Tissue Term	Sub-tissue Term
Cardiovascular System	arteries	arteries_abdominal aorta
Cardiovascular System	arteries	arteries_aorta
```
## スクリプト
### オントロジーファイル作成
TiSMeD 定義の組織分類に ID を割り当てる。  
```
awk -f scripts/tissue_hierarchy_ids.awk data/tismed_tissue_hierarchy.tsv > data/tismed_tissue_ids.tsv``
`
ラベルを UBERON にマッピング。EBI OLS の MCP サーバーを使ってマッピングを実施した結果を `/data/tismed_tissue_ids_with_uberon.tsv` として配置した。  

これをオントロジーの turtle ファイルに変換する。  
```
awk -f scripts/generate_ontology.awk data/tismed_tissue_uberon_mapping.tsv data/tismed_tissue_hierarchy.tsv > output/tismed_ontology.ttl
```

### 本体の RDF ファイル作成
```
awk -f scripts/convert_tsgs.awk data/tismed_tissue_uberon_mapping.tsv TSGs.tsv > output/TSGs.ttl
```

TSPs.tsv は、列名と内容が揃っていないことがあるので、事前に修復する。  
```
awk -f scripts/restore_tsps.awk TSPs.tsv > TSPs_restored.tsv
awk -f scripts/convert_tsps.awk data/tismed_tissue_uberon_mapping.tsv TSPs_restored.tsv > output/TSPs.ttl
```
