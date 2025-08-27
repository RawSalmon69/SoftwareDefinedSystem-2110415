2110415/2110506 Software-defined Systems
Activity: Docker Compose
1. ให้นิสิตติดตั้ง application ที่ประกอบด้วย
1) node_exporter 3 replicas
2) prometheus
3) grafana
- project name คือ monitoring
- ใช้ custom network ชื่อ "monitoring"
- กำหนด resource limit สำหรับ node_exporter ให้ใช้ CPU ได้ไม่เกิน 25%
- กำหนด dependencies ที่เหมำะสม
- Prometheus ดึงข้อมูลจำก node_exporter ทุก replicas
Hint: เขียน prometheus.yml ให้ตั้ง targets เป็น arrays
- targets: [monitoring-node-exporter-1:9100, monitoring-node-exporter-2:9100, monitoring-node-exporter-3:9100]
หรือ
- targets:
- monitoring-node-exporter-1:9100
- monitoring-node-exporter-2:9100
- monitoring-node-exporter-3:9100
- ใช้ Docker Compose บนคอมพิวเตอร์ 1 เครื่อง ด้วยคำสั่ง
docker compose up --scale node-exporter=3 -d
- รันคำสั่งต่อไปนี้เพื่อให้ node-exporter ใช้ CPU
docker exec -d monitoring-node-exporter-1 sh -c "while true; do echo > /dev/null; done"
docker exec -d monitoring-node-exporter-2 sh -c "while true; do echo > /dev/null; done"
docker exec -d monitoring-node-exporter-3 sh -c "while true; do echo > /dev/null; done"
- ใช้ Grafana สร้ำง dashboard เพื่อ monitor metrics node_load1
- รันโปรแกรม grader ขณะที่ทุก service ทำงำนอยู่ (รำยละเอียดของโปรแกรมจะแจ้งใน myCourseVille
สิ่งที่ต้องส่ง
- ไฟล์ compose.yml
- ไฟล์ prometheus.yml
- screen capture กำรรันคำสั่ง docker stats
- screen capture หน้ำจอของ Grafana: http://localhost:3000 แสดง metrics node_load1 ตัวอย่ำงเช่น
(หมำยเหตุ: node_load1 วัด load ของเครื่อง ไม่ใช่เฉพำะ container เนื่องจำก node-exporter ทั้ง 3 ตัว รันอยู่บนเครื่องเดียวกัน
จึงรำยงำนผลใกล้เคียงกัน ถ้ำอยู่คนละเครื่องก็จะต่ำงกัน)