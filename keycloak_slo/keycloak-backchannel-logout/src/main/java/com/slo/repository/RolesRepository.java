package com.slo.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.slo.entity.Roles;

@Repository
public interface RolesRepository extends JpaRepository<Roles, Long> {

}
