export default {
  async fetch(request: Request, env: any) {
    const url = new URL(request.url);
    const db = env.DB;

    if (url.pathname === "/summary") {
      const { results: milkRows } = await db
        .prepare("SELECT COALESCE(SUM(net_units), 0) AS total_milk FROM produce")
        .all();
      const { results: factoryRows } = await db
        .prepare("SELECT COUNT(*) AS factory_count FROM factories")
        .all();
      const { results: farmerRows } = await db
        .prepare("SELECT COUNT(*) AS farmer_count FROM farmers")
        .all();

      const total_milk = milkRows?.[0]?.total_milk ?? 0;
      const factory_count = factoryRows?.[0]?.factory_count ?? 0;
      const farmer_count = farmerRows?.[0]?.farmer_count ?? 0;

      return Response.json({
        dairy_summary: "KG-ERP Live on Cloudflare D1",
        total_milk_kg: Number(total_milk).toFixed(2),
        factories: Number(factory_count),
        farmers: Number(farmer_count),
        last_updated: new Date().toISOString()
      }, { headers: { "Content-Type": "application/json" } });
    }

    if (url.pathname === "/health") {
      const tables = await db.prepare("SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE '_cf_%' AND name != 'sqlite_sequence' ORDER BY name").all();
      return Response.json({
        status: "DB HEALTHY",
        tables: tables.results.map((r: any) => r.name),
        timestamp: new Date().toISOString()
      });
    }

    return new Response(`
      <h1>D1 Dairy ERP</h1>
      <p><a href="/health">Health Check</a> | <a href="/summary">Milk Summary</a></p>
      <p>AI Query API coming soon...</p>
    `, { headers: { "Content-Type": "text/html" } });
  }
};
