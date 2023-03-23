--not sure if migrate scripting is the done thing for inserts but hey....    
DO $$
BEGIN
   IF EXISTS (
      SELECT FROM information_schema.tables
      WHERE  table_schema = 'example'
      AND  table_name = 'car_emissions') THEN
    TRUNCATE TABLE EXAMPLE.CAR_EMISSIONS;
   END IF;
END $$;

