package org.ecommerce;

import io.quarkus.runtime.QuarkusApplication;
import io.quarkus.runtime.ShutdownEvent;
import io.quarkus.runtime.annotations.QuarkusMain;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.enterprise.event.Observes;
import jakarta.inject.Inject;
import lombok.extern.slf4j.Slf4j;
import org.flywaydb.core.Flyway;

@QuarkusMain
@ApplicationScoped
@Slf4j
public class FlywayMain implements QuarkusApplication {

    @Inject
    Flyway flyway;

    void onStop(@Observes ShutdownEvent ev) {
        log.info("Stopping Flyway one-shot runner");
    }

    @Override
    public int run(String... args) {
        try {
            log.info("Starting Flyway migration (one-shot mode)...");
            var result = flyway.migrate();
            log.info("Flyway migration finished. Migrations executed: {}", result.migrationsExecuted);
            return 0; // exit after running once
        } catch (Exception e) {
            log.error("Flyway migration failed", e);
            return 1; // non-zero exit code on failure
        }
    }
}
